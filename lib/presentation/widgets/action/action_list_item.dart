import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class ActionListItem extends StatelessWidget {
  final dynamic item;
  final String title;
  final SvgGenImage icon;
  final Color? iconTintColor;
  final Color? textColor;
  final Function(dynamic item) onClicked;

  const ActionListItem({
    super.key,
    required this.item,
    required this.title,
    required this.icon,
    this.iconTintColor,
    this.textColor,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Material(
        color: StaticColors.innerCardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            onClicked(item);
            HapticFeedback.selectionClick();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                icon.svg(width: 24, height: 24, color: iconTintColor),
                SizedBox(width: 24),
                title.s(16).w(400).c(textColor ?? context.textPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
