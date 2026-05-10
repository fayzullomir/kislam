import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'main_cubit.dart';

@RoutePage()
class MainPage extends BasePage<MainCubit, MainState, MainEvent> {
  const MainPage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, MainState state) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        QuranRoute(),
        PrayRoute(),
        LearnRoute(),
        ProfileRoute(),
      ],
      transitionBuilder: (context, child, animation) => child,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return PopScope(
          canPop: tabsRouter.activeIndex == 0,
          onPopInvokedWithResult: (bool didPop, dynamic result) {
            if (!didPop && tabsRouter.activeIndex != 0) {
              tabsRouter.setActiveIndex(0);
            }
          },
          child: Scaffold(
            backgroundColor: IslamicDesignTokens.neutral,
            body: child,
            bottomNavigationBar: _NoorBottomNavBar(
              activeIndex: tabsRouter.activeIndex,
              onTap: tabsRouter.setActiveIndex,
            ),
          ),
        );
      },
    );
  }
}

/// Noor bottom navigation — minimal, no rounded shell, with a soft pill
/// outline around the active tab to mirror the K-Islam UI Kit.
class _NoorBottomNavBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _NoorBottomNavBar({
    required this.activeIndex,
    required this.onTap,
  });

  List<_NavItemConfig> get _items => [
        _NavItemConfig(
          label: Strings.bottomNavigationHome,
          icon: Icons.home_outlined,
          activeIcon: Icons.home_rounded,
        ),
        _NavItemConfig(
          label: Strings.bottomNavigationQuran,
          icon: Icons.menu_book_outlined,
          activeIcon: Icons.menu_book_rounded,
        ),
        _NavItemConfig(
          label: Strings.bottomNavigationPray,
          icon: Icons.mosque_outlined,
          activeIcon: Icons.mosque,
        ),
        _NavItemConfig(
          label: Strings.bottomNavigationLearn,
          icon: Icons.search_outlined,
          activeIcon: Icons.search_rounded,
        ),
        _NavItemConfig(
          label: Strings.bottomNavigationProfile,
          icon: Icons.person_outline_rounded,
          activeIcon: Icons.person_rounded,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: IslamicDesignTokens.neutral,
        border: Border(
          top: BorderSide(color: IslamicDesignTokens.line, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
          child: Row(
            children: List.generate(_items.length, (index) {
              return Expanded(
                child: _NavItem(
                  config: _items[index],
                  isActive: index == activeIndex,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final _NavItemConfig config;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.config,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? IslamicDesignTokens.primary
        : IslamicDesignTokens.inkSoft;

    // Soft outline pill around the active tab — matches the new design's
    // gentle highlight; transparent border keeps inactive tabs at the same
    // height so labels never jump.
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? IslamicDesignTokens.primary.withOpacity(0.35)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? config.activeIcon : config.icon,
                color: color,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                config.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontBody,
                  color: color,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemConfig {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItemConfig({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
