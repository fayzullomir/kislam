import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/widgets/shimmer/shimmer_container_widget.dart';
import 'package:koreaislam/presentation/widgets/shimmer/shimmer_item_widget.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerContainerWidget(
      margin: EdgeInsets.only(left: 12, top: 20, right: 12, bottom: 8),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Padding(
        padding: EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
        child: Row(
          children: [
            ShimmerItemWidget(
              width: 120,
              height: 56,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerItemWidget(height: 14),
                  SizedBox(height: 4),
                  ShimmerItemWidget(width: 190, height: 14),
                  SizedBox(height: 4),
                  ShimmerItemWidget(width: 175, height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
