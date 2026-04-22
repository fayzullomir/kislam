import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/domain/models/media/media_file.dart';

import 'compression_result.dart';

export 'compression_result.dart';

/// Image compression helper with recursive approach until target size
class PhotoCompressUtils {
  PhotoCompressUtils._();

  // Size limits
  static const int maxSize = 10 * 1024 * 1024; // 10 MB
  static const int targetSize = 2 * 1024 * 1024; // 2 MB

  // Compression settings
  static const int _maxIterations = 10;

  /// Compress single image recursively until target size is reached
  /// If [deleteOriginal] is true, the original file will be deleted after successful compression
  static Future<CompressionResult> compress(
    XFile file, {
    bool deleteOriginal = false,
  }) async {
    final inputFile = File(file.path);
    final originalPath = file.path;

    if (!await inputFile.exists()) {
      AppLog.e('ImageCompressHelper: File not found: ${file.path}');
      return CompressionResult.error(file, 0);
    }

    final originalSize = await inputFile.length();
    final tempFiles = <String>[];

    try {
      final tempDir = await getTemporaryDirectory();
      String currentPath = file.path;
      int currentSize = originalSize;
      int iterations = 0;

      // Recursive compression until target size or max iterations
      while (currentSize > targetSize && iterations < _maxIterations) {
        // Calculate quality based on how far we are from target
        final ratio = targetSize / currentSize;
        int quality;
        int minWidth;
        int minHeight;

        if (ratio < 0.1) {
          // Very large file (>20MB) - aggressive compression
          quality = 40 - (iterations * 5);
          minWidth = 1024 - (iterations * 100);
          minHeight = 576 - (iterations * 50);
        } else if (ratio < 0.3) {
          // Large file (7-20MB) - medium compression
          quality = 55 - (iterations * 5);
          minWidth = 1280 - (iterations * 80);
          minHeight = 720 - (iterations * 50);
        } else if (ratio < 0.6) {
          // Medium file (3-7MB) - light compression
          quality = 70 - (iterations * 5);
          minWidth = 1440 - (iterations * 60);
          minHeight = 810 - (iterations * 40);
        } else {
          // Small file (2-3MB) - minimal compression
          quality = 80 - (iterations * 5);
          minWidth = 1920 - (iterations * 50);
          minHeight = 1080 - (iterations * 30);
        }

        // Clamp values
        quality = quality.clamp(15, 90);
        minWidth = minWidth.clamp(480, 1920);
        minHeight = minHeight.clamp(270, 1080);

        final targetPath =
            '${tempDir.path}/img_${DateTime.now().millisecondsSinceEpoch}_$iterations.jpg';

        final result = await FlutterImageCompress.compressAndGetFile(
          currentPath,
          targetPath,
          quality: quality,
          minWidth: minWidth,
          minHeight: minHeight,
        );

        if (result == null) {
          AppLog.w('Image compression iteration $iterations returned null');
          break;
        }

        final newSize = await result.length();
        tempFiles.add(targetPath);
        iterations++;

        AppLog.d(
          'Image compression iteration $iterations: '
          '${CompressionResult.formatSize(newSize)} (q:$quality, w:$minWidth)',
        );

        // Accept if smaller
        if (newSize < currentSize) {
          currentPath = result.path;
          currentSize = newSize;
        } else {
          // No improvement, stop
          AppLog.d('No improvement, stopping at iteration $iterations');
          break;
        }
      }

      // Clean up intermediate temp files (keep only the last one)
      await _cleanupTempFiles(tempFiles, keepLast: currentPath);

      // Delete original file if requested and compression was successful
      if (deleteOriginal && currentPath != originalPath) {
        await _safeDeleteFile(originalPath);
        AppLog.d('PhotoCompressHelper: Deleted original file: $originalPath');
      }

      return CompressionResult(
        file: XFile(currentPath),
        originalSize: originalSize,
        compressedSize: currentSize,
        iterations: iterations,
        reachedTargetSize: currentSize <= targetSize,
      );
    } catch (e, stack) {
      AppLog.e('ImageCompressHelper error', error: e, stackTrace: stack);
      await _cleanupTempFiles(tempFiles);
      return CompressionResult.error(file, originalSize);
    }
  }

  /// Compress multiple images with progress callback
  /// If [deleteOriginal] is true, the original files will be deleted after successful compression
  static Future<List<CompressionResult>> compressMultiple(
    List<XFile> files, {
    void Function(int completed, int total)? onProgress,
    bool deleteOriginal = false,
  }) async {
    final results = <CompressionResult>[];

    for (int i = 0; i < files.length; i++) {
      final result = await compress(files[i], deleteOriginal: deleteOriginal);
      results.add(result);
      onProgress?.call(i + 1, files.length);
    }

    return results;
  }

  // ==================== VALIDATION ====================

  static Future<int> getFileSize(XFile file) async {
    try {
      final f = File(file.path);
      if (await f.exists()) {
        return await f.length();
      }
    } catch (e) {
      AppLog.e('getFileSize error', error: e);
    }
    return 0;
  }

  static Future<bool> fileExists(XFile file) async {
    return File(file.path).exists();
  }

  // ==================== CONVERSION ====================

  static MediaFile toMediaFile(XFile file) {
    return MediaFile(localMediaFile: file);
  }

  static MediaFile resultToMediaFile(CompressionResult result) {
    return MediaFile(localMediaFile: result.file);
  }

  // ==================== PRIVATE HELPERS ====================

  static Future<void> _cleanupTempFiles(
    List<String> paths, {
    String? keepLast,
  }) async {
    for (final path in paths) {
      if (path != keepLast) {
        await _safeDeleteFile(path);
      }
    }
  }

  static Future<void> _safeDeleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      AppLog.w('Failed to delete temp file: $path');
    }
  }
}
