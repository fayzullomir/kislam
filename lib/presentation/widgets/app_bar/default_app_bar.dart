import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/platform_sizes.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? titleTextColor;
  final Color backgroundColor;
  final VoidCallback onBackPressed;
  final PreferredSizeWidget? bottom;

  const DefaultAppBar({
    super.key,
    required this.title,
    this.titleTextColor,
    this.backgroundColor = Colors.transparent,
    required this.onBackPressed,
    this.bottom,
  });

  @override
  Size get preferredSize =>  Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AppBar(
      backgroundColor: backgroundColor,
      systemOverlayStyle:
          isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: appBarHeight,
      title: title.s(16).w(500).c(titleTextColor ?? context.textPrimary),
      leading: IconButton(
        onPressed: onBackPressed,
        icon: Transform.flip(
          flipX: isRtl,
          child: Assets.images.appBar.actionBack.svg(
            height: 20,
            width: 20,
            color: context.iconPrimary,
          ),
        ),
      ),
      bottom: bottom,
    );
  }
}
