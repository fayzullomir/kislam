import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StudentShimmerWidget extends StatelessWidget {
  const StudentShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Shimmer.fromColors(
          baseColor: StaticColors.shimmerBaseColor,
          highlightColor: StaticColors.shimmerHighLightColor,
          child: Row(
            children: [
              // Аватар
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              // Имя и фамилия
              Container(
                height: 14,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
