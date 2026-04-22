import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class RatingBarWidget extends StatelessWidget {
  final double ratingAvg;
  final double starSize;
  final double textSize;
  final double spaceBetweenRatingAndBar;
  final int? ratingCount;
  final bool isRatingShowInLeft;

  const RatingBarWidget({
    Key? key,
    required this.ratingAvg,
    this.starSize = 13,
    this.textSize = 13,
    this.ratingCount,
    this.isRatingShowInLeft = true,
    this.spaceBetweenRatingAndBar = 2,
  }) : super(key: key);

  bool get _isRatingShowInRight => !isRatingShowInLeft;

  bool get _isRatingCountVisible => ratingCount != null && ratingCount! > 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isRatingShowInLeft) ...[
          ..._buildRatingAndCount(context),
          SizedBox(width: spaceBetweenRatingAndBar),
        ],
        _buildRatingBar(),
        if (_isRatingShowInRight) ...[
          SizedBox(width: spaceBetweenRatingAndBar),
          ..._buildRatingAndCount(context),
        ],
      ],
    );
  }

  List<Widget> _buildRatingAndCount(BuildContext context) {
    return [
      ratingAvg.toStringAsFixed(1).s(textSize).w(600).c(context.textPrimary),
      if (_isRatingCountVisible) ...[
        const SizedBox(width: 4),
        "(${_formatRatingCount(ratingCount!)})"
            .s(textSize)
            .w(400)
            .c(context.textSecondary),
      ],
    ];
  }

  Widget _buildRatingBar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) {
          return _getStarAsset(index).svg(
            color: StaticColors.colorAccent,
            width: starSize,
            height: starSize,
          );
        },
      ),
    );
  }

  SvgGenImage _getStarAsset(int index) {
    final rating = ratingAvg;

    if (index < rating.floor()) {
      return Assets.images.component.ratingBarStarFilled;
    } else if (index < rating && rating % 1 != 0) {
      return Assets.images.component.ratingBarStarHalfFilled;
    } else {
      return Assets.images.component.ratingBarStarUnfilled;
    }
  }

  String _formatRatingCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
