import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/widgets/image/network_rounded_image_widget.dart';

class BannerWidget extends StatelessWidget {
  final String imageUrl;

  const BannerWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return NetworkRoundedImageWidget(
      imageUrl: imageUrl,
    );
  }
}
