import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class ProfileItemWidget extends StatelessWidget {
  final String name;
  final Color? textColor;
  final SvgGenImage icon;
  final Color? iconColor;
  final VoidCallback onClicked;
  final double topRadius;
  final double bottomRadius;
  final bool isShaderMask;

  const ProfileItemWidget({
    super.key,
    required this.name,
    this.textColor,
    required this.icon,
    this.iconColor,
    required this.onClicked,
    this.topRadius = 0,
    this.bottomRadius = 0,
    this.isShaderMask = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: () => onClicked(),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(bottomRadius),
            topLeft: Radius.circular(topRadius),
            topRight: Radius.circular(topRadius),
            bottomRight: Radius.circular(bottomRadius),
          ),
          child: Container(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildIcon(),
                    SizedBox(width: 16),
                    name.w(500).s(14).c(textColor ?? context.textPrimary)
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget _buildIcon() {
    Color actualIconColor = iconColor ?? StaticColors.colorAccent;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: actualIconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: icon.svg(width: 18, height: 18, color: actualIconColor),
    );
  }
}
