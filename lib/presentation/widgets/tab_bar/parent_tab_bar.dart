import 'package:koreaislam/core/extensions/map_extensions.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:flutter/material.dart';

class ParentTabBar extends StatefulWidget {
  final TabController controller;
  final List<String> tabs;
  final double borderRadius;
  final bool isScrollable;

  const ParentTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.borderRadius = 12, this.isScrollable=true,
  });

  @override
  State<ParentTabBar> createState() => _ParentTabBarState();
}

class _ParentTabBarState extends State<ParentTabBar> {
  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: TabBar(
        isScrollable: widget.isScrollable,
        controller: widget.controller,
        physics: const BouncingScrollPhysics(),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: context.primaryLight,
          // gradient: context.appBarGradient,
        ),
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        splashBorderRadius: BorderRadius.circular(widget.borderRadius),
        splashFactory: NoSplash.splashFactory,
        enableFeedback: false,
        tabs: widget.tabs.mapWithIndex((index, text) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(index == 0 ? widget.borderRadius:0),
                bottomLeft: Radius.circular(index == 0 ? widget.borderRadius:0),
                topRight: Radius.circular(index+1 == widget.tabs.length ? widget.borderRadius:0),
                bottomRight: Radius.circular(index+1 == widget.tabs.length ? widget.borderRadius:0),
              ),
              // color: Colors.white.withValues(alpha:0.1),
            ),

            child: _AppTab(
              index: index,
              text: text,
              controller: widget.controller,
              borderRadius: widget.borderRadius,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AppTab extends StatefulWidget {
  final int index;
  final String text;
  final TabController controller;
  final double borderRadius;

  const _AppTab({
    required this.index,
    required this.text,
    required this.controller,
    required this.borderRadius,
  });

  @override
  State<_AppTab> createState() => _AppTabState();
}

class _AppTabState extends State<_AppTab> {
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    widget.controller.animation?.addListener(_updateOpacity);
    _updateOpacity();
  }

  @override
  void dispose() {
    widget.controller.animation?.removeListener(_updateOpacity);
    super.dispose();
  }

  void _updateOpacity() {
    final value = widget.controller.animation?.value ?? widget.controller.index.toDouble();
    double result;

    if (value < widget.index - 1 || value > widget.index + 1) {
      result = 0;
    } else if (value <= widget.index) {
      result = value - (widget.index - 1);
    } else {
      result = 1 - (value - widget.index);
    }

    setState(() {
      opacity = result.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Tab(
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          onTap: () => widget.controller.animateTo(widget.index),
          child: Stack(
            alignment: Alignment.center,
            children: [
              widget.text.s(12).w(500).c(context.textPrimary).copyWith(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              Opacity(
                opacity: opacity,
                child: widget.text.s(12).w(500).c(context.textPrimaryInverse).copyWith(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}