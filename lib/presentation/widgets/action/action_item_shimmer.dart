import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/widgets/shimmer/shimmer_container_widget.dart';
import 'package:koreaislam/presentation/widgets/shimmer/shimmer_item_widget.dart';

class ActionItemShimmer extends StatelessWidget {
  const ActionItemShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerContainerWidget(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          ShimmerItemWidget(width: 20, height: 20),
          SizedBox(width: 16),
          ShimmerItemWidget(width: 150, height: 12),
          Spacer(),
          ShimmerItemWidget(width: 20, height: 20),
        ],
      ),
    );
  }
}
