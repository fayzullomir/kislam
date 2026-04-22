import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/widgets/shimmer/shimmer_container_widget.dart';
import 'package:koreaislam/presentation/widgets/shimmer/shimmer_item_widget.dart';

class PublishedArticleShimmer extends StatelessWidget {
  final Axis axis;

  // Private constructor
  const PublishedArticleShimmer._({
    super.key,
    required this.axis,
  });

  // ✅ Named constructor - Vertical
  const PublishedArticleShimmer.vertical({Key? key})
      : this._(
          key: key,
          axis: Axis.vertical,
        );

  // ✅ Named constructor - Horizontal
  const PublishedArticleShimmer.horizontal({Key? key})
      : this._(
          key: key,
          axis: Axis.horizontal,
        );

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.horizontal) {
      return _buildHorizontalShimmer();
    } else {
      return _buildVerticalShimmer();
    }
  }

  Widget _buildHorizontalShimmer() {
    return ShimmerContainerWidget(
      width: 260,
      height: 160,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(left: 12, top: 12, right: 12),
      child: Column(
        children: [
          ShimmerItemWidget(
            height: 80,
            borderRadius: BorderRadius.circular(8),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              ShimmerItemWidget(width: 40, height: 22),
              SizedBox(width: 6),
              ShimmerItemWidget(width: 40, height: 22),
              Spacer(),
              ShimmerItemWidget(width: 40, height: 22),
            ],
          ),
          SizedBox(height: 10),
          ShimmerItemWidget(height: 14),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerItemWidget(width: 90, height: 14),
              ShimmerItemWidget(width: 80, height: 14),
            ],
          ),
          SizedBox(height: 12)
        ],
      ),
    );
  }

  Widget _buildVerticalShimmer() {
    return ShimmerContainerWidget(
      padding: EdgeInsets.only(left: 12, top: 12, right: 12),
      child: Column(
        children: [
          ShimmerItemWidget(
            height: 100,
            borderRadius: BorderRadius.circular(8),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              ShimmerItemWidget(width: 30, height: 30),
              SizedBox(width: 6),
              ShimmerItemWidget(width: 30, height: 30),
              Spacer(),
              ShimmerItemWidget(width: 30, height: 30),
            ],
          ),
          SizedBox(height: 10),
          ShimmerItemWidget(height: 14),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerItemWidget(width: 90, height: 14),
              ShimmerItemWidget(width: 80, height: 14),
            ],
          ),
          SizedBox(height: 12)
        ],
      ),
    );
  }
}
