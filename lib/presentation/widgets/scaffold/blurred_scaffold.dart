import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/app_bar/scroll_fade_app_bar.dart';

class BlurredScaffold extends StatelessWidget {
  final Widget appBar;
  final Widget body;
  final double appBarHeight;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? appBarMargin;
  final EdgeInsetsGeometry? appBarPadding;

  const BlurredScaffold({
    super.key,
    required this.appBar,
    required this.body,
    this.appBarHeight = 61,
    this.floatingActionButton,
    this.appBarMargin,
    this.appBarPadding,
  });

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.pageBackgroundColor,
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            ScrollFadeAppBar(
              expandedHeight: appBarHeight,
              pinned: true,
              floating: true,
              snap: false,
              elevation: 0,
              leadingWidth: 0,
              automaticallyImplyLeading: false,
              flexibleSpaceBuilder: (opacity) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (opacity > 0.5)
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                  ],
                );
              },
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(appBarHeight),
                child: Container(
                  padding:
                      appBarPadding ?? EdgeInsets.symmetric(horizontal: 20),
                  margin: appBarMargin ?? EdgeInsets.fromLTRB(0, 6, 0, 10),
                  child: appBar,
                ),
              ),
              scrollController: scrollController,
              fadeStartOffset: 50,
            ),
          ];
        },
        body: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
