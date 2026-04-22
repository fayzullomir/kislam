import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/platform_sizes.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final Color? textColor;
  final Color backgroundColor;

  const EmptyAppBar({
    super.key,
    required this.titleText,
    this.textColor,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Size get preferredSize =>  Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: backgroundColor,
      systemOverlayStyle:
          isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: appBarHeight,
      title: titleText.s(18).w(500).c(textColor ?? context.textPrimary),
    );
  }
}
