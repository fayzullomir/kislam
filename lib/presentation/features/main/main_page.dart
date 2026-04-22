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
        LearnRoute(),
        KnowledgeRoute(),
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
            backgroundColor: IslamicDesignTokens.background,
            body: child,
            bottomNavigationBar: _IslamicBottomNavBar(
              activeIndex: tabsRouter.activeIndex,
              onTap: tabsRouter.setActiveIndex,
            ),
          ),
        );
      },
    );
  }
}

class _IslamicBottomNavBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _IslamicBottomNavBar({
    required this.activeIndex,
    required this.onTap,
  });

  List<_NavItemConfig> get _items => [
    _NavItemConfig(label: Strings.bottomNavigationHome, icon: Icons.home_outlined, activeIcon: Icons.home_rounded),
    _NavItemConfig(label: Strings.bottomNavigationQuran, icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book_rounded),
    _NavItemConfig(label: Strings.bottomNavigationLearn, icon: Icons.school_outlined, activeIcon: Icons.school_rounded),
    _NavItemConfig(label: Strings.bottomNavigationKnowledge, icon: Icons.quiz_outlined, activeIcon: Icons.quiz_rounded),
    _NavItemConfig(label: Strings.bottomNavigationProfile, icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: IslamicDesignTokens.background,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        child: Container(
          decoration: BoxDecoration(
            color: IslamicDesignTokens.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = index == activeIndex;
              return _NavItem(
                config: item,
                isActive: isActive,
                onTap: () => onTap(index),
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
        : IslamicDesignTokens.textMuted;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? config.activeIcon : config.icon,
                  color: color,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  config.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
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
