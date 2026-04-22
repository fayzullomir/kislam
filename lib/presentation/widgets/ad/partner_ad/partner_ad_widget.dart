import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/domain/models/ad/partner_ad/partner_ads.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:koreaislam/presentation/widgets/image/network_rounded_image_widget.dart';

class PartnerAdWidget extends StatelessWidget {
  final PartnerAd ad;
  final Function(PartnerAd ad) onClicked;
  final Function(PartnerAd ad) onBuyClicked;

  const PartnerAdWidget({
    super.key,
    required this.onClicked,
    required this.onBuyClicked,
    required this.ad,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      borderRadius: BorderRadius.circular(6),
      width: 150,
      child: InkWell(
        onTap: () => onClicked(ad),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                NetworkRoundedImageWidget(
                  imageUrl: ad.adPhoto,
                  height: 100,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: context.textPrimaryInverse.withOpacity(0.75),
                    padding: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    child: ad.productName.s(13).w(500).copyWith(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ad.formattedPrice
                  .s(13)
                  .w(400)
                  .c(context.colorAccent)
                  .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
