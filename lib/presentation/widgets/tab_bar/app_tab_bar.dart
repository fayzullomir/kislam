import 'package:koreaislam/core/extensions/map_extensions.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class AppTabBar extends StatefulWidget {
  final TabController controller;
  final List<String> tabs;
  final double borderRadius;

  const AppTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.borderRadius = 60,
  });

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.controller,
      physics: const BouncingScrollPhysics(),
      indicator: UnderlineTabIndicator(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(width: 2.5, color: StaticColors.colorAccent),
        insets: const EdgeInsets.symmetric(horizontal: 16),
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      tabs: widget.tabs.mapWithIndex((index, text) {
        return AppTab(
          index: index,
          text: text,
          controller: widget.controller,
        );
      }).toList(),
    );
  }
}

class AppTab extends StatelessWidget {
  final int index;
  final String text;
  final TabController controller;

  const AppTab({
    super.key,
    required this.index,
    required this.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {

    return Tab(
      child: AnimatedBuilder(
        animation: controller.animation!,
        builder: (_, __) {
          final selected = controller.index == index;
          // final gradient = context.appBarGradient;

          final baseText = Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: selected ? StaticColors.colorAccent : context.textSecondary,
            ),
          );

          // return selected
          //     ? ShaderMask(
          //         shaderCallback: (bounds) => gradient.createShader(
          //             Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          //         blendMode: BlendMode.srcIn,
          //         child: baseText,
          //       )
          //     : baseText;
              return baseText;
        },
      ),
    );
  }
}
