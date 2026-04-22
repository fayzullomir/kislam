import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/widgets/shimmer/shimmer_container_widget.dart';
import 'package:koreaislam/presentation/widgets/shimmer/shimmer_item_widget.dart';

class PartnerAdShimmer extends StatelessWidget {
  const PartnerAdShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerContainerWidget(
      borderRadius: BorderRadius.circular(6),
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: ShimmerItemWidget(
              width: double.maxFinite,
              height: 76,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: ShimmerItemWidget(height: 12),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
