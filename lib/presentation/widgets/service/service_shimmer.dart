import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/widgets/shimmer/shimmer_container_widget.dart';
import 'package:koreaislam/presentation/widgets/shimmer/shimmer_item_widget.dart';

class ServiceShimmer extends StatelessWidget {
  const ServiceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerContainerWidget(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
          child: Row(
            children: [
              _buildIcon(context),
              SizedBox(width: 12),
              _buildLabel(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: ShimmerItemWidget(
        width: 24,
        height: 24,
      ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Flexible(
      child: Column(
        children: const [
          Row(
            children: [
              ShimmerItemWidget(width: 80, height: 14),
              SizedBox(width: 6),
              ShimmerItemWidget(width: 60, height: 14),
              SizedBox(width: 6),
              ShimmerItemWidget(width: 70, height: 14),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              ShimmerItemWidget(width: 50, height: 14),
              SizedBox(width: 6),
              ShimmerItemWidget(width: 70, height: 14),
              SizedBox(width: 6),
              ShimmerItemWidget(width: 60, height: 14),
              SizedBox(width: 6),
              ShimmerItemWidget(width: 50, height: 14),
            ],
          ),
        ],
      ),
    );
  }
}
