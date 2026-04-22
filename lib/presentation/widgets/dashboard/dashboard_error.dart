import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardError extends StatelessWidget {
  final VoidCallback? onRetryClicked;
  const DashboardError({super.key, this.onRetryClicked});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 64),
          Strings.validationErrorMessage
              .s(14)
              .w(400)
              .c(context.textPrimary),
          SizedBox(height: 12),
          if (onRetryClicked != null)
            MaterialElevatedButton(
              text: Strings.commonRetry,
              width: 180,
              onPressed: () {
                if (onRetryClicked != null) onRetryClicked!();
              },
            ),
          SizedBox(height: 64)
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

