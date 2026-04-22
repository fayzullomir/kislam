import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 64),
          Shimmer.fromColors(
            baseColor: StaticColors.shimmerBaseColor,
            highlightColor: StaticColors.shimmerHighLightColor,
            child: Container(
              width: 64,
              height: 16,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(height: 18),
          Shimmer.fromColors(
            baseColor: StaticColors.shimmerBaseColor,
            highlightColor: StaticColors.shimmerHighLightColor,
            child: Container(
              width: 48,
              height: 16,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(height: 18),
          Shimmer.fromColors(
            baseColor: StaticColors.shimmerBaseColor,
            highlightColor: StaticColors.shimmerHighLightColor,
            child: Container(
              width: 64,
              height: 16,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(height: 18),
          Shimmer.fromColors(
            baseColor: StaticColors.shimmerBaseColor,
            highlightColor: StaticColors.shimmerHighLightColor,
            child: Container(
              width: 32,
              height: 16,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}

class DonutShape extends StatelessWidget {
  const DonutShape({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: StaticColors.shimmerBaseColor,
          highlightColor: StaticColors.shimmerHighLightColor,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.brown[400],
              shape: BoxShape.circle,
            ),
          ),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: context.customCardBackground,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

/*
 children: [
              "${stats.autoAttCount}"
                  .s(16)
                  .w(600)
                  .c(StaticColors.attendanceAuto),
              SizedBox(height: 2),
              Strings.commonAttTypeAuto
                  .s(12)
                  .w(400)
                  .c(context.textPrimary)
                  .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: 6),
              CustomDivider(
                thickness: 1,
                color: Color(0xFFEFEFEF),
                endIndent: 24,
              ),
              SizedBox(height: 4),
              "${stats.manualAttCount}"
                  .s(16)
                  .w(600)
                  .c(StaticColors.attendanceManual),
              SizedBox(height: 2),
              Strings.commonAttTypeManual
                  .s(12)
                  .w(400)
                  .c(context.textPrimary)
                  .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: 6),
              CustomDivider(
                thickness: 1,
                color: Color(0xFFEFEFEF),
                endIndent: 24,
              ),
              SizedBox(height: 4),
              "${stats.totalAbsentCount}"
                  .s(16)
                  .w(600)
                  .c(StaticColors.attendanceAbsent),
              SizedBox(height: 2),
              Strings.commonAttAbsent
                  .s(12)
                  .w(400)
                  .c(context.textPrimary)
                  .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: 6),
              CustomDivider(
                thickness: 1,
                color: Color(0xFFEFEFEF),
                endIndent: 24,
              ),
              SizedBox(height: 4),
              "${stats.spoofedAttCount}"
                  .s(16)
                  .w(600)
                  .c(StaticColors.attendanceSpoofed),
              SizedBox(height: 2),
              Strings.commonAttSuspicious
                  .s(12)
                  .w(400)
                  .c(context.textPrimary)
                  .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
            ]
 */
