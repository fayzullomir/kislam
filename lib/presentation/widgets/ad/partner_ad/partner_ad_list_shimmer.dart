import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/widgets/ad/partner_ad/partner_ad_shimmer.dart';

class PartnerAdListShimmer extends StatelessWidget {
  const PartnerAdListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 146,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 9,
        padding: EdgeInsets.only(left: 16, top:3, right: 16, bottom: 3),
        itemBuilder: (context, index) {
          return PartnerAdShimmer();
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 10);
        },
      ),
    );
  }
}
