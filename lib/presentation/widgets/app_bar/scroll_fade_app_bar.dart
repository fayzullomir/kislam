import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScrollFadeAppBar extends StatelessWidget {
  final ScrollController scrollController;
  final double expandedHeight;
  final double fadeStartOffset;
  final Widget Function(double opacity) flexibleSpaceBuilder;
  final PreferredSizeWidget? bottom;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double elevation;
  final double leadingWidth;
  final bool automaticallyImplyLeading;

  const ScrollFadeAppBar({
    required this.scrollController,
    required this.expandedHeight,
    required this.fadeStartOffset,
    required this.flexibleSpaceBuilder,
    this.bottom,
    this.pinned = false,
    this.floating = false,
    this.snap = false,
    this.elevation = 4.0,
    this.leadingWidth = 56.0,
    this.automaticallyImplyLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SliverAppBar(
      systemOverlayStyle: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      snap: snap,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leadingWidth: leadingWidth,
      backgroundColor: Colors.transparent,
      // Фон должен быть прозрачным
      flexibleSpace: _buildFlexibleSpace(isDarkMode),
      bottom: bottom,
    );
  }

  Widget _buildFlexibleSpace(bool isDarkMode) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!isDarkMode) return flexibleSpaceBuilder(0.8);
        double scrollOffset =
            scrollController.hasClients ? scrollController.offset : 0.0;

        // Определяем прозрачность
        double opacity = (scrollOffset / fadeStartOffset).clamp(0.0, 1.0);

        return flexibleSpaceBuilder(opacity);
      },
    );
  }
}
