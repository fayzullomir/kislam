import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/platform_sizes.dart';

class ActionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final VoidCallback onBackPressed;
  // @override
  final List<Widget>? actions;
  // @override
  final Color backgroundColor;
  final Color titleTextColor;

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  ActionAppBar({
    super.key,
    required this.titleText,
    required this.titleTextColor,
    required this.backgroundColor,
    required this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: appBarHeight,
      systemOverlayStyle:
          isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      title: titleText.s(18).w(500).c(titleTextColor),
      leading: Transform.flip(
        flipX: isRtl,
        child: IconButton(
          onPressed: onBackPressed,
          icon: Assets.images.appBar.actionBack.svg(
            height: 24,
            width: 24,
            color: context.iconPrimary,
          ),
        ),
      ),
      actions: actions,
    );
  }
}
