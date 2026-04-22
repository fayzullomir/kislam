import 'package:koreaislam/core/extensions/double_extensions.dart';

class PartnerAd {
  final String adId;
  final String productName;
  final String productId;
  final String partnerName;
  final String partnerUrl;
  final String brandName;
  final List<String> adPhotos;
  final double price;
  final bool isLiked;

  String get adPhoto => adPhotos.first;

  String get formattedPrice => price.formattedWithSpace;

  PartnerAd({
    required this.adId,
    required this.productName,
    required this.productId,
    required this.partnerName,
    required this.partnerUrl,
    required this.brandName,
    required this.adPhotos,
    required this.price,
    this.isLiked = false,
  });
}
