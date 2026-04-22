import 'package:image_picker/image_picker.dart';

/// Result of media compression operation
class CompressionResult {
  final XFile file;
  final int originalSize;
  final int compressedSize;
  final int iterations;
  final bool reachedTargetSize;

  const CompressionResult({
    required this.file,
    required this.originalSize,
    required this.compressedSize,
    this.iterations = 1,
    this.reachedTargetSize = false,
  });

  /// Create error result (returns original file)
  factory CompressionResult.error(XFile file, int originalSize) {
    return CompressionResult(
      file: file,
      originalSize: originalSize,
      compressedSize: originalSize,
      iterations: 0,
      reachedTargetSize: false,
    );
  }

  /// Compression ratio (0.0 - 1.0, lower = better compression)
  double get ratio =>
      originalSize > 0 ? compressedSize / originalSize : 1.0;

  /// Percentage of size reduced
  double get savedPercent => (1 - ratio) * 100;

  /// Whether compression actually reduced the file size
  bool get wasCompressed => compressedSize < originalSize;

  /// Whether the compressed file is within upload limit
  bool isWithinUploadLimit(int maxUploadSize) =>
      compressedSize <= maxUploadSize;

  /// Human-readable summary
  String get summary =>
      '${formatSize(originalSize)} → ${formatSize(compressedSize)} '
          '(${savedPercent.toStringAsFixed(1)}% saved, $iterations iterations, '
          'target: ${reachedTargetSize ? "✓" : "✗"})';

  /// Format bytes to human-readable string
  static String formatSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}