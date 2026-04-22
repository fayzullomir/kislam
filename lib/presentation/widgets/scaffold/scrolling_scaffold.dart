import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';

class ScrollingScaffold extends StatelessWidget {
  final Widget appBar;
  final Widget body;
  final double appBarHeight;
  final Widget? floatingActionButton;
  final bool isUseTopPadding;
  final EdgeInsetsGeometry? appBarMargin;
  final EdgeInsetsGeometry? appBarPadding;

  const ScrollingScaffold({
    super.key,
    required this.appBar,
    required this.body,
    this.appBarHeight = 56,
    this.isUseTopPadding = false,
    this.floatingActionButton,
    this.appBarMargin,
    this.appBarPadding,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final actualAppBarHeight =
        isUseTopPadding ? appBarHeight + topPadding : appBarHeight;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.pageBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: actualAppBarHeight,
              floating: true,
              pinned: false,
              snap: true,
              elevation: 0,
              leadingWidth: 0,
              automaticallyImplyLeading: false,
              backgroundColor: context.appBarColor,
              flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
                  child: Container(
                    padding: appBarPadding,
                    margin: appBarMargin,
                    child: appBar,
                  ),
                ),
              ),
            ),
          ];
        },
        body: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
