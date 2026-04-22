import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InfoCardShimmer extends StatelessWidget {
  const InfoCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      borderRadius: BorderRadius.circular(12),
      child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child:  Shimmer.fromColors(
          baseColor: StaticColors.shimmerBaseColor,
          highlightColor: StaticColors.shimmerHighLightColor,
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
