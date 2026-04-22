import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:light_compressor/light_compressor.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/domain/models/media/media_file.dart';

import 'compression_result.dart';

export 'compression_result.dart';

/// Video compression utility using LightCompressor (Telegram-based algorithm)
///
/// Uses native MediaCodec (Android) / AVFoundation (iOS) for efficient
/// streaming compression. Handles large files (1GB+) without memory issues.
///
/// Strategy:
/// - Single-pass compression with adaptive quality selection
/// - Files ≤ targetSize (8MB): no compression needed
/// - If first pass doesn't reach target, retries once with lower quality
/// - Quality auto-selected based on file size for best size/quality balance
class VideoCompressUtils {
  VideoCompressUtils._();

  // Size limits
  static const int maxUploadSize = 10 * 1024 * 1024; // 10 MB (upload limit)
  static const int targetSize = 8 * 1024 * 1024; // 8 MB (compression target)

  // Singleton LightCompressor instance for cancel support
  static final LightCompressor _compressor = LightCompressor();

  /// Compress video using native codec (single-pass, streaming)
  ///
  /// [onProgress] reports 0.0 to 1.0
  /// [deleteOriginal] deletes source file after successful compression
  static Future<CompressionResult> compress(
      XFile file, {
        void Function(double progress)? onProgress,
        bool deleteOriginal = false,
      }) async {
    final inputFile = File(file.path);
    final originalPath = file.path;

    if (!await inputFile.exists()) {
      AppLog.e('VideoCompressUtils: File not found: ${file.path}');
      return CompressionResult.error(file, 0);
    }

    final originalSize = await inputFile.length();

    // Already within target — no compression needed
    if (originalSize <= targetSize) {
      AppLog.d('VideoCompressUtils: File already within target size');
      onProgress?.call(1.0);
      return CompressionResult(
        file: file,
        originalSize: originalSize,
        compressedSize: originalSize,
        iterations: 0,
        reachedTargetSize: true,
      );
    }

    AppLog.d(
      'VideoCompressUtils: Starting compression '
          '${CompressionResult.formatSize(originalSize)}',
    );

    // Select quality based on file size
    final quality = _selectQuality(originalSize);
    final canRetry = _canRetryWithLowerQuality(quality);

    // Progress scaling: first pass = 0-80% (if retry possible), else 0-100%
    final firstPassMax = canRetry ? 0.80 : 1.0;

    StreamSubscription<double>? progressSubscription;

    try {
      progressSubscription = _compressor.onProgressUpdated.listen((percent) {
        final normalized = (percent / 100).clamp(0.0, 0.99);
        onProgress?.call(normalized * firstPassMax);
      });

      final videoName = 'vid_${DateTime.now().millisecondsSinceEpoch}.mp4';

      AppLog.d('VideoCompressUtils: Using quality=${quality.name}');

      final Result response = await _compressor.compressVideo(
        path: file.path,
        videoQuality: quality,
        isMinBitrateCheckEnabled: false,
        video: Video(videoName: videoName),
        android: AndroidConfig(isSharedStorage: false),
        ios: IOSConfig(saveInGallery: false),
      );

      await progressSubscription.cancel();
      progressSubscription = null;

      if (response is OnSuccess) {
        final outputPath = response.destinationPath;
        final outputFile = File(outputPath);

        if (!await outputFile.exists()) {
          AppLog.e('VideoCompressUtils: Output file not found: $outputPath');
          return CompressionResult.error(file, originalSize);
        }

        final compressedSize = await outputFile.length();

        AppLog.d(
          'VideoCompressUtils: Pass 1 result '
              '${CompressionResult.formatSize(originalSize)} → '
              '${CompressionResult.formatSize(compressedSize)}',
        );

        // If compression made file larger, return original
        if (compressedSize >= originalSize) {
          AppLog.w(
              'VideoCompressUtils: Compressed file is larger, using original');
          await _safeDeleteFile(outputPath);
          return CompressionResult(
            file: file,
            originalSize: originalSize,
            compressedSize: originalSize,
            iterations: 1,
            reachedTargetSize: originalSize <= targetSize,
          );
        }

        // Try retry if first pass didn't reach target
        if (compressedSize > targetSize) {
          final lowerQuality = _getLowerQuality(quality);

          if (lowerQuality != null && compressedSize > targetSize * 1.2) {
            final retryResult = await _retryWithLowerQuality(
              outputPath,
              originalSize,
              compressedSize,
              lowerQuality,
              onProgress: (progress) {
                onProgress?.call(0.80 + (progress * 0.20));
              },
            );

            if (retryResult != null) {
              await _safeDeleteFile(outputPath);
              if (deleteOriginal) await _safeDeleteFile(originalPath);
              onProgress?.call(1.0);
              return retryResult;
            }
          }
        }

        onProgress?.call(1.0);

        if (deleteOriginal && outputPath != originalPath) {
          await _safeDeleteFile(originalPath);
        }

        return CompressionResult(
          file: XFile(outputPath),
          originalSize: originalSize,
          compressedSize: compressedSize,
          iterations: 1,
          reachedTargetSize: compressedSize <= targetSize,
        );
      } else if (response is OnFailure) {
        AppLog.e(
            'VideoCompressUtils: Compression failed: ${response.message}');
        return CompressionResult.error(file, originalSize);
      } else if (response is OnCancelled) {
        AppLog.d('VideoCompressUtils: Compression cancelled');
        return CompressionResult.error(file, originalSize);
      }

      return CompressionResult.error(file, originalSize);
    } catch (e, stack) {
      AppLog.e('VideoCompressUtils: Error', error: e, stackTrace: stack);
      await progressSubscription?.cancel();
      return CompressionResult.error(file, originalSize);
    }
  }

  /// Retry compression with explicitly lower quality
  static Future<CompressionResult?> _retryWithLowerQuality(
      String inputPath,
      int originalSize,
      int currentSize,
      VideoQuality quality, {
        void Function(double progress)? onProgress,
      }) async {
    StreamSubscription<double>? sub;

    try {
      AppLog.d('VideoCompressUtils: Retry with quality=${quality.name}');

      sub = _compressor.onProgressUpdated.listen((percent) {
        final normalized = (percent / 100).clamp(0.0, 0.99);
        onProgress?.call(normalized);
      });

      final videoName =
          'vid_retry_${DateTime.now().millisecondsSinceEpoch}.mp4';

      final Result response = await _compressor.compressVideo(
        path: inputPath,
        videoQuality: quality,
        isMinBitrateCheckEnabled: false,
        video: Video(videoName: videoName),
        android: AndroidConfig(isSharedStorage: false),
        ios: IOSConfig(saveInGallery: false),
      );

      await sub.cancel();
      sub = null;

      if (response is OnSuccess) {
        final outputFile = File(response.destinationPath);
        if (!await outputFile.exists()) return null;

        final retrySize = await outputFile.length();

        if (retrySize < currentSize) {
          AppLog.d(
            'VideoCompressUtils: Retry success '
                '${CompressionResult.formatSize(retrySize)}',
          );

          return CompressionResult(
            file: XFile(response.destinationPath),
            originalSize: originalSize,
            compressedSize: retrySize,
            iterations: 2,
            reachedTargetSize: retrySize <= targetSize,
          );
        } else {
          await _safeDeleteFile(response.destinationPath);
          AppLog.d('VideoCompressUtils: Retry did not improve, discarding');
        }
      }
    } catch (e) {
      AppLog.e('VideoCompressUtils: Retry error', error: e);
      await sub?.cancel();
    }

    return null;
  }

  // ==================== QUALITY SELECTION ====================

  static VideoQuality _selectQuality(int fileSize) {
    final sizeInMB = fileSize / (1024 * 1024);

    if (sizeInMB > 500) return VideoQuality.very_low;
    if (sizeInMB > 200) return VideoQuality.low;
    if (sizeInMB > 50) return VideoQuality.medium;
    if (sizeInMB > 20) return VideoQuality.high;
    return VideoQuality.very_high;
  }

  static VideoQuality? _getLowerQuality(VideoQuality current) {
    switch (current) {
      case VideoQuality.very_high:
        return VideoQuality.high;
      case VideoQuality.high:
        return VideoQuality.medium;
      case VideoQuality.medium:
        return VideoQuality.low;
      case VideoQuality.low:
        return VideoQuality.very_low;
      case VideoQuality.very_low:
        return null;
    }
  }

  static bool _canRetryWithLowerQuality(VideoQuality quality) {
    return quality != VideoQuality.very_low;
  }

  // ==================== CANCEL ====================

  static void cancelCompression() {
    try {
      _compressor.cancelCompression();
    } catch (e) {
      AppLog.e('VideoCompressUtils: cancelCompression error', error: e);
    }
  }

  // ==================== VALIDATION ====================

  static Future<int> getFileSize(XFile file) async {
    try {
      final f = File(file.path);
      if (await f.exists()) return await f.length();
    } catch (e) {
      AppLog.e('VideoCompressUtils: getFileSize error', error: e);
    }
    return 0;
  }

  static Future<bool> fileExists(XFile file) => File(file.path).exists();

  // ==================== CONVERSION ====================

  static MediaFile toMediaFile(XFile file) {
    return MediaFile(localMediaFile: file);
  }

  static MediaFile resultToMediaFile(CompressionResult result) {
    return MediaFile(localMediaFile: result.file);
  }

  // ==================== PRIVATE ====================

  static Future<void> _safeDeleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (e) {
      AppLog.w('VideoCompressUtils: Failed to delete: $path');
    }
  }
}