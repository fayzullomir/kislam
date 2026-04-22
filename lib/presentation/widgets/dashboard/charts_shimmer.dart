
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../support/colors/static_colors.dart';

class ChartsShimmer extends StatelessWidget{
  const ChartsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 64,
      width: 64,
      child: Stack(
        children: [
          Shimmer.fromColors(
            baseColor: StaticColors.shimmerBaseColor,
            highlightColor: StaticColors.shimmerHighLightColor,
            child: Container(
              margin: EdgeInsets.all(4),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(360)),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.all(4),
              height: 44.8,
              width: 44.8,
              decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(360)),
            ),
          )
        ],
      ),
    );
  }

}