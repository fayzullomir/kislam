import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/domain/models/media/media_file.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/state_message/state_bottom_sheet_exts.dart';
import 'package:koreaislam/presentation/support/state_message/state_message.dart';
import 'package:koreaislam/presentation/support/state_message/state_message_type.dart';
import 'package:koreaislam/presentation/widgets/action/action_list_item.dart';
import 'package:koreaislam/presentation/widgets/bottom_sheet/bottom_sheet_title.dart';
import 'package:koreaislam/presentation/widgets/image/network_rounded_image_widget.dart';
import 'package:koreaislam/presentation/widgets/text/description_text_widget.dart';
import 'package:koreaislam/utils/compress/photo_compress_utils.dart';

/// Max upload size for photos (same as server limit)
const int _maxPhotoUploadSize = 10 * 1024 * 1024; // 10 MB

class PhotoListPickerWidget extends StatefulWidget {
  final List<MediaFile>? initialImages;
  final int maxCount;
  final double horizontalPadding;
  final AutovalidateMode? autoValidateMode;
  final String? Function(int count)? validator;
  final ValueChanged<List<MediaFile>>? onImagesChanged;

  const PhotoListPickerWidget({
    super.key,
    this.initialImages,
    required this.maxCount,
    this.horizontalPadding = 0,
    this.autoValidateMode,
    this.validator,
    this.onImagesChanged,
  });

  @override
  State<PhotoListPickerWidget> createState() => _PhotoListPickerWidgetState();
}

class _PhotoListPickerWidgetState extends State<PhotoListPickerWidget> {
  late List<MediaFile> _images;
  bool _isCompressing = false;
  int _compressingTotal = 0;
  int _compressedCount = 0;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.initialImages ?? []);
  }

  @override
  void didUpdateWidget(covariant PhotoListPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialImages != oldWidget.initialImages) {
      _images = List.from(widget.initialImages ?? []);
    }
  }

  void _notifyImagesChanged() {
    widget.onImagesChanged?.call(List.from(_images));
  }

  Future<void> _pickImages() async {
    if (_isCompressing) return;

    if (_images.length >= widget.maxCount) {
      _showMaxCountError();
      return;
    }

    try {
      final picker = ImagePicker();
      final pickedImages = await picker.pickMultiImage();

      if (pickedImages.isEmpty) return;

      final availableSlots = widget.maxCount - _images.length;
      final imagesToProcess = pickedImages.take(availableSlots).toList();

      if (imagesToProcess.isEmpty) return;

      setState(() {
        _isCompressing = true;
        _compressingTotal = imagesToProcess.length;
        _compressedCount = 0;
      });

      final results = await PhotoCompressUtils.compressMultiple(
        imagesToProcess,
        onProgress: (completed, total) {
          if (mounted) {
            setState(() => _compressedCount = completed);
          }
        },
      );

      if (!mounted) return;

      // Filter out images that exceed upload limit
      int skippedCount = 0;
      final mediaFiles = <MediaFile>[];
      for (final result in results) {
        if (result.isWithinUploadLimit(_maxPhotoUploadSize)) {
          mediaFiles.add(PhotoCompressUtils.resultToMediaFile(result));
        } else {
          skippedCount++;
          AppLog.w(
            'PhotoListPicker: Skipped image '
            '${CompressionResult.formatSize(result.compressedSize)} '
            '(exceeds upload limit)',
          );
        }
      }

      setState(() {
        _images.addAll(mediaFiles);
        _isCompressing = false;
      });

      _notifyImagesChanged();

      // Show warnings
      if (skippedCount > 0) {
        _showSizeLimitError(skippedCount);
      } else if (pickedImages.length > availableSlots) {
        _showMaxCountError();
      }
    } catch (e, stack) {
      AppLog.e('pickImages error', error: e, stackTrace: stack);
      if (mounted) {
        setState(() => _isCompressing = false);
      }
    }
  }

  void _removeImage(MediaFile file) {
    setState(() {
      _images.removeWhere((e) => e.isSame(file));
    });
    _notifyImagesChanged();
    HapticFeedback.lightImpact();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = _images.removeAt(oldIndex);
      _images.insert(newIndex, item);
    });
    _notifyImagesChanged();
    HapticFeedback.lightImpact();
  }

  Future<void> _onImageClicked(int index) async {
    final result = await context.router.push(
      LocaleImageViewerRoute(
        images: _images,
        initialIndex: index,
      ),
    );

    if (result != null && result is List<MediaFile>) {
      setState(() => _images = List.from(result));
      _notifyImagesChanged();
      HapticFeedback.lightImpact();
    }
  }

  void _showMaxCountError() {
    context.showStateMessageBottomSheet(StateMessage(
      MessageType.warning,
      Strings.photoListPickerMaxCountError('${widget.maxCount}'),
    ));
  }

  void _showSizeLimitError(int skippedCount) {
    if (!mounted) return;
    final limitText = CompressionResult.formatSize(_maxPhotoUploadSize);
    final message = skippedCount == 1
        ? Strings.photoListPickerSizeLimitSingle(limitText)
        : Strings.photoListPickerSizeLimitMultiple('$skippedCount', limitText);

    context.showStateBottomSheet(
      title: Strings.photoListPickerSizeLimitTitle,
      message: message,
      type: MessageType.warning,
    );
  }

  void _showPickerTypeBottomSheet() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Material(
          child: Container(
            decoration: BoxDecoration(
              color: context.bottomSheetColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                BottomSheetTitle(title: Strings.addImageActionTitle),
                const SizedBox(height: 16),
                ActionListItem(
                  item: '',
                  title: Strings.addImageActionPickImage,
                  icon: Assets.images.component.photoPick,
                  iconTintColor: context.iconPrimary,
                  onClicked: (item) {
                    Navigator.pop(context);
                    _pickImages();
                  },
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (v) => widget.validator?.call(_images.length),
      builder: (state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageList(),
            const SizedBox(height: 8),
            DescriptionTextWidget(
              text: Strings.photoListPickerMainImageDesc,
              padding:
                  EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            ),
            if (state.hasError) ...[
              const SizedBox(height: 8),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
                child: state.errorText!
                    .s(12)
                    .c(Colors.red)
                    .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildImageList() {
    return SizedBox(
      height: 82,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            SizedBox(width: widget.horizontalPadding),
            _buildPhotoPick(),
            ReorderableListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 6, right: 10),
              proxyDecorator:
                  (Widget child, int index, Animation<double> animation) {
                return Material(
                  elevation: 0,
                  animationDuration: Duration.zero,
                  color: Colors.transparent,
                  child: child,
                );
              },
              onReorderStart: (index) => HapticFeedback.lightImpact(),
              onReorder: (int oldIndex, int newIndex) {
                if (newIndex > oldIndex) newIndex--;
                _onReorder(oldIndex, newIndex);
              },
              children: _images
                  .mapIndexed((index, media) => Padding(
                        key: ValueKey(media),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _buildPhotoPreview(media, index),
                      ))
                  .toList(),
            ),
            SizedBox(width: widget.horizontalPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPick() {
    return InkWell(
      onTap: () {
        if (_isCompressing) return;

        if (_images.length < widget.maxCount) {
          _showPickerTypeBottomSheet();
        } else {
          _showMaxCountError();
        }
        HapticFeedback.lightImpact();
      },
      child: Container(
        height: 82,
        width: 96,
        decoration: BoxDecoration(
          color: context.inputBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          shape: BoxShape.rectangle,
          border: Border.all(
            color: context.inputStrokeColor,
            width: 1,
          ),
        ),
        child: Center(
          child: _isCompressing
              ? _buildCompressingIndicator()
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

  Widget _buildCompressingIndicator() {
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
        const SizedBox(height: 4),
        Text(
          '$_compressedCount/$_compressingTotal',
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFFA3A3A3),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoPreview(MediaFile photo, int index) {
    return Stack(
      key: ValueKey(photo),
      children: [
        InkWell(
          onTap: () => _onImageClicked(index),
          child: Container(
            height: 82,
            width: 96,
            decoration: BoxDecoration(
              color: const Color(0XFFFBFAFF),
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
              border: Border.all(
                color: const Color(0xFFDFE2E9),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildPhotoImage(photo),
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: InkWell(
            onTap: () => _removeImage(photo),
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

  Widget _buildPhotoImage(MediaFile photo) {
    if (photo.isNotUploaded()) {
      final path = photo.localMediaFile?.path;
      if (path == null || path.isEmpty) {
        return const SizedBox.shrink();
      }

      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image, color: Colors.grey, size: 24),
        ),
      );
    }

    return NetworkRoundedImageWidget(
      imageUrl: photo.uploadedFileUrl ?? '',
    );
  }
}
