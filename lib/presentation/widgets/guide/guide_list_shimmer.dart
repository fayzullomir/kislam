import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/widgets/guide/guide_shimmer.dart';
import 'package:koreaislam/presentation/widgets/responsive/responsive_builder.dart';

class GuideListShimmer extends StatelessWidget {
  const GuideListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildVerticalShimmerList(context);
  }

  Widget _buildVerticalShimmerList(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context) => ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 48),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) => GuideShimmer(),
        separatorBuilder: (BuildContext c, int index) => SizedBox(height: 10),
      ),
      tablet: (context) => GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 48),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          mainAxisExtent: 70,
        ),
        itemCount: 12,
        itemBuilder: (BuildContext buildContext, int index) {
          return GuideShimmer();
        },
      ),
    );
  }
}
