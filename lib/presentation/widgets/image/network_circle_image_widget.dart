import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/cache/CustomCacheManager.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class NetworkCircleImageWidget extends StatelessWidget {
  const NetworkCircleImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.placeHolderImage,
    this.errorImage,
    this.border,
    this.contentPadding,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final Widget? placeHolderImage;
  final Widget? errorImage;
  final BorderSide? border;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: imageUrl,
      cacheManager: CustomCacheManager.imageCacheManager,
      fadeInDuration: const Duration(milliseconds: 500),
      fadeOutDuration: const Duration(milliseconds: 300),
      errorListener: (e) {
        AppLog.e("Error loading image from imageUrl: $imageUrl, error : $e");
      },
      imageBuilder: (context, imageProvider) => _buildImage(imageProvider),
      placeholder: (context, url) => _buildPlaceHolderImage(context),
      errorWidget: (context, url, error) => _buildErrorImage(context),
    );
  }

  Widget _buildImage(ImageProvider<Object> imageProvider) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border != null ? Border.fromBorderSide(border!) : null,
      ),
      padding: contentPadding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceHolderImage(BuildContext context) {
    return Container(
      padding: contentPadding,
      decoration: BoxDecoration(
        color: context.cardColor,
        shape: BoxShape.circle,
        border: border != null ? Border.fromBorderSide(border!) : null,
      ),
      child: placeHolderImage != null ? Center(child: placeHolderImage) : null,
    );
  }

  Widget _buildErrorImage(BuildContext context) {
    return Container(
      padding: contentPadding,
      decoration: BoxDecoration(
        color: context.cardColor,
        shape: BoxShape.circle,
        border: border != null ? Border.fromBorderSide(border!) : null,
      ),
      child: errorImage != null ? Center(child: errorImage) : null,
    );
  }
}
