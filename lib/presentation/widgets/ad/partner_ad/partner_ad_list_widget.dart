import 'package:flutter/material.dart';
import 'package:koreaislam/domain/models/ad/partner_ad/partner_ads.dart';
import 'package:koreaislam/presentation/widgets/ad/partner_ad/partner_ad_widget.dart';

class PartnerAdListWidget extends StatelessWidget {
  final List<PartnerAd> ads;
  final Function(PartnerAd ad) onItemClicked;
  final Function(PartnerAd ad) onBuyPressed;

  const PartnerAdListWidget({
    super.key,
    required this.ads,
    required this.onItemClicked,
    required this.onBuyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 146,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: ads.length,
        padding: EdgeInsets.only(left: 16, top:3, right: 16, bottom: 3),
        itemBuilder: (context, index) {
          return PartnerAdWidget(
            ad: ads[index],
            onClicked: onItemClicked,
            onBuyClicked: onBuyPressed,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 10);
        },
      ),
    );
  }
}
