import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class ChipItem extends StatelessWidget {
  final dynamic item;
  final String title;
  final double verticalPadding;
  final double horizontalPadding;
  final Function(dynamic item)? onChipClicked;
  final Function(dynamic item)? onActionClicked;

  const ChipItem({
    super.key,
    required this.item,
    required this.title,
    this.verticalPadding = 10,
    this.horizontalPadding = 14,
    this.onChipClicked,
    this.onActionClicked,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onChipClicked != null) onChipClicked!(item);
      },
      borderRadius: BorderRadius.all(Radius.circular(24)),
      child: Container(
        padding: EdgeInsets.only(
          left: horizontalPadding,
          top: verticalPadding,
          right:
              onActionClicked != null ? verticalPadding - 2 : verticalPadding,
          bottom: verticalPadding,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          border: Border.all(
              width: 1, color: context.materialOutlinedButtonStroke.withOpacity(0.6)),
          shape: BoxShape.rectangle,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            title
                .w(600)
                .s(13)
                // .c(Color(0xFF5C6AC4))
                .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
            SizedBox(width: 14),
            if (onActionClicked != null)
              InkWell(
                onTap: () {
                  onActionClicked!(item);
                  HapticFeedback.lightImpact();
                },
                child: Assets.images.component.chipClose
                    .svg(height: 20, width: 20),
              ),
          ],
        ),
      ),
    );
  }
}
