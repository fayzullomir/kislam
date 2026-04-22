import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/domain/models/media/media_file.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/state_message/state_bottom_sheet_exts.dart';
import 'package:koreaislam/presentation/support/state_message/state_message_type.dart';
import 'package:koreaislam/utils/compress/video_compress_utils.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoPickerWidget extends StatefulWidget {
  final MediaFile? initialVideo;
  final AutovalidateMode? autoValidateMode;
  final String? Function(MediaFile? video)? validator;
  final ValueChanged<MediaFile?>? onVideoChanged;
  final Duration maxDuration;

  const VideoPickerWidget({
    super.key,
    this.initialVideo,
    this.autoValidateMode,
    this.validator,
    this.onVideoChanged,
    this.maxDuration = const Duration(minutes: 5),
  });

  @override
  State<VideoPickerWidget> createState() => _VideoPickerWidgetState();
}

class _VideoPickerWidgetState extends State<VideoPickerWidget> {
  MediaFile? _video;
  Uint8List? _thumbnail;
  bool _isProcessing = false;
  double _compressionProgress = 0;
  String _statusText = '';

  @override
  void initState() {
    super.initState();
    _video = widget.initialVideo;
    if (_video != null) {
      _generateThumbnail(_video!.localMediaFile?.path);
    }
  }

  @override
  void didUpdateWidget(covariant VideoPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialVideo != oldWidget.initialVideo) {
      _video = widget.initialVideo;
      _thumbnail = null;
      if (_video != null) {
        _generateThumbnail(_video!.localMediaFile?.path);
      }
    }
  }

  @override
  void dispose() {
    if (_isProcessing) {
      VideoCompressUtils.cancelCompression();
    }
    super.dispose();
  }

  Future<void> _generateThumbnail(String? path) async {
    if (path == null || path.isEmpty) return;

    try {
      final thumbnail = await VideoThumbnail.thumbnailData(
        video: path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 300,
        quality: 75,
      );

      if (mounted && thumbnail != null) {
        setState(() => _thumbnail = thumbnail);
      }
    } catch (e) {
      AppLog.e('VideoPickerWidget: generateThumbnail error', error: e);
    }
  }

  Future<void> _pickVideo() async {
    if (_isProcessing) return;

    try {
      final picker = ImagePicker();
      final pickedVideo = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: widget.maxDuration,
      );

      if (pickedVideo == null) return;

      final initialSize = await VideoCompressUtils.getFileSize(pickedVideo);
      final formattedSize = CompressionResult.formatSize(initialSize);

      setState(() {
        _isProcessing = true;
        _thumbnail = null;
        _compressionProgress = 0;
        _statusText = Strings.videoPickerPreparing(formattedSize);
      });

      final result = await VideoCompressUtils.compress(
        pickedVideo,
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              _compressionProgress = progress;
              if (progress < 0.95) {
                _statusText = Strings.videoPickerCompressing;
              } else {
                _statusText = Strings.videoPickerFinishing;
              }
            });
          }
        },
      );

      if (!mounted) return;

      AppLog.d('VideoPickerWidget: Compression complete: ${result.summary}');

      // Check if compressed file exceeds upload limit
      if (!result.isWithinUploadLimit(VideoCompressUtils.maxUploadSize)) {
        final sizeText = CompressionResult.formatSize(result.compressedSize);
        final limitText =
            CompressionResult.formatSize(VideoCompressUtils.maxUploadSize);

        setState(() {
          _isProcessing = false;
          _statusText = '';
          _compressionProgress = 0;
        });

        if (mounted) {
          context.showStateBottomSheet(
            title: Strings.videoPickerSizeLimitTitle,
            message: Strings.videoPickerSizeLimitMessage(limitText, sizeText),
            type: MessageType.warning,
          );
        }
        return;
      }

      // Generate thumbnail from compressed video
      setState(() => _statusText = Strings.videoPickerGeneratingThumbnail);
      await _generateThumbnail(result.file.path);

      if (!mounted) return;

      setState(() {
        _video = VideoCompressUtils.resultToMediaFile(result);
        _isProcessing = false;
        _statusText = '';
        _compressionProgress = 0;
      });

      widget.onVideoChanged?.call(_video);
      HapticFeedback.lightImpact();
    } catch (e, stack) {
      AppLog.e('VideoPickerWidget: pickVideo error',
          error: e, stackTrace: stack);
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _statusText = '';
          _compressionProgress = 0;
        });
        _showError(Strings.videoPickerUploadError);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _removeVideo() {
    setState(() {
      _video = null;
      _thumbnail = null;
    });
    widget.onVideoChanged?.call(null);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<MediaFile?>(
      validator: (v) => widget.validator?.call(_video),
      autovalidateMode: widget.autoValidateMode,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _video == null ? _buildPickButton() : _buildVideoPreview(),
            if (state.hasError) ...[
              const SizedBox(height: 8),
              state.errorText!
                  .s(12)
                  .c(Colors.red)
                  .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPickButton() {
    return InkWell(
      onTap: _pickVideo,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: context.inputBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: context.inputStrokeColor,
            width: 1,
          ),
        ),
        child: Center(
          child: _isProcessing
              ? _buildProcessingIndicator()
              : Assets.images.component.videoPick.svg(
                  height: 36,
                  width: 36,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFA3A3A3),
                    BlendMode.srcIn,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildProcessingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 48,
            width: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _compressionProgress > 0 ? _compressionProgress : null,
                  strokeWidth: 3,
                  color: context.colorAccent,
                  backgroundColor: context.inputStrokeColor,
                ),
                if (_compressionProgress > 0)
                  Text(
                    '${(_compressionProgress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: context.colorAccent,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _statusText,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFA3A3A3),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Stack(
      children: [
        InkWell(
          onTap: _isProcessing ? null : _pickVideo,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFDFE2E9),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildThumbnail(),
                  _buildPlayOverlay(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: InkWell(
            onTap: _removeVideo,
            child: Assets.images.component.photoRemove.svg(
              fit: BoxFit.contain,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail() {
    if (_thumbnail != null) {
      return Image.memory(
        _thumbnail!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _buildThumbnailPlaceholder(),
      );
    }

    if (_video?.isNotUploaded() == true) {
      return Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: context.colorAccent,
          ),
        ),
      );
    }

    return _buildThumbnailPlaceholder();
  }

  Widget _buildThumbnailPlaceholder() {
    return Container(color: const Color(0xFF2A2A2A));
  }

  Widget _buildPlayOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: StaticColors.colorPrimary.withValues(alpha: 0.5),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: Assets.images.component.videoPlay.svg(
            height: 24,
            width: 24,
            colorFilter: const ColorFilter.mode(
              StaticColors.colorPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
