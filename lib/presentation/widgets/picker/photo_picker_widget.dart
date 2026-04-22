import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/domain/models/media/media_file.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/state_message/state_bottom_sheet_exts.dart';
import 'package:koreaislam/presentation/support/state_message/state_message_type.dart';
import 'package:koreaislam/presentation/widgets/image/network_rounded_image_widget.dart';
import 'package:koreaislam/utils/compress/photo_compress_utils.dart';

/// Max upload size for photos (same as server limit)
const int _maxPhotoUploadSize = 10 * 1024 * 1024; // 10 MB

class PhotoPickerWidget extends StatefulWidget {
  final MediaFile? initialImage;
  final AutovalidateMode? autoValidateMode;
  final String? Function(MediaFile? image)? validator;
  final ValueChanged<MediaFile?>? onPhotoDefined;
  final double height;

  const PhotoPickerWidget({
    super.key,
    this.initialImage,
    this.autoValidateMode,
    this.validator,
    this.onPhotoDefined,
    this.height = 160,
  });

  @override
  State<PhotoPickerWidget> createState() => _PhotoPickerWidgetState();
}

class _PhotoPickerWidgetState extends State<PhotoPickerWidget> {
  MediaFile? _image;
  bool _isCompressing = false;

  @override
  void initState() {
    super.initState();
    _image = widget.initialImage;
  }

  @override
  void didUpdateWidget(covariant PhotoPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialImage != oldWidget.initialImage) {
      _image = widget.initialImage;
    }
  }

  Future<void> _pickImage() async {
    if (_isCompressing) return;

    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage == null) return;

      setState(() => _isCompressing = true);

      final result = await PhotoCompressUtils.compress(pickedImage);

      if (!mounted) return;

      AppLog.d('Photo compression: ${result.summary}');

      // Check if compressed file exceeds upload limit
      if (!result.isWithinUploadLimit(_maxPhotoUploadSize)) {
        setState(() => _isCompressing = false);
        _showSizeLimitError(result.compressedSize);
        return;
      }

      setState(() {
        _image = PhotoCompressUtils.resultToMediaFile(result);
        _isCompressing = false;
      });

      widget.onPhotoDefined?.call(_image);
      HapticFeedback.lightImpact();
    } catch (e, stack) {
      AppLog.e('pickImage error', error: e, stackTrace: stack);
      if (mounted) {
        setState(() => _isCompressing = false);
      }
    }
  }

  void _removeImage() {
    setState(() => _image = null);
    widget.onPhotoDefined?.call(null);
    HapticFeedback.lightImpact();
  }

  void _showSizeLimitError(int compressedSize) {
    if (!mounted) return;
    final sizeText = CompressionResult.formatSize(compressedSize);
    final limitText = CompressionResult.formatSize(_maxPhotoUploadSize);

    context.showStateBottomSheet(
      title: Strings.photoPickerSizeLimitTitle,
      message: Strings.photoPickerSizeLimitMessage(limitText, sizeText),
      type: MessageType.warning,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<MediaFile?>(
      validator: (v) => widget.validator?.call(_image),
      autovalidateMode: widget.autoValidateMode,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _image == null ? _buildPickButton() : _buildImagePreview(),
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
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: context.inputBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: context.inputStrokeColor,
            width: 1,
          ),
        ),
        child: Center(
          child: _isCompressing
              ? _buildLoadingIndicator()
              : Assets.images.component.photoAdd.svg(
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

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: context.colorAccent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          Strings.photoPickerCompressing,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFA3A3A3),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: context.inputBackgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFDFE2E9),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: _buildImage(),
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: InkWell(
            onTap: _removeImage,
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

  Widget _buildImage() {
    final image = _image!;

    if (image.isNotUploaded()) {
      final path = image.localMediaFile?.path;
      if (path == null || path.isEmpty) {
        return const SizedBox.shrink();
      }

      return Image.file(
        File(path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }

    return NetworkRoundedImageWidget(
      imageUrl: image.uploadedFileUrl ?? '',
    );
  }
}
