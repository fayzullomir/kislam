import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_app_bar.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_mock_data.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'home_cubit.dart';

@RoutePage()
class HomePage extends BasePage<HomeCubit, HomeState, HomeEvent> {
  const HomePage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, HomeState state) {
    final displayName =
        state.fullName.isEmpty ? 'Kim Cheol-su' : state.fullName;
    return Scaffold(
      backgroundColor: IslamicDesignTokens.background,
      appBar: IslamicAppBar(
        title: IslamicMockData.appTitle,
        onNotificationTap: () => context.router.push(NotificationListRoute()),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _GreetingBlock(name: displayName),
            const SizedBox(height: 20),
            _PrayerTimesCard(),
            const SizedBox(height: 24),
            _QuickActionsGrid(
              onActionTap: (action) {
                switch (action.id) {
                  case HomeQuickActionId.quran:
                    context.tabsRouter.setActiveIndex(1);
                    break;
                  case HomeQuickActionId.howToPray:
                    context.tabsRouter.setActiveIndex(2);
                    break;
                  case HomeQuickActionId.dua:
                  case HomeQuickActionId.findHalal:
                    context.tabsRouter.setActiveIndex(3);
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetingBlock extends StatelessWidget {
  final String name;

  const _GreetingBlock({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.homeGreeting,
          style: const TextStyle(
            color: IslamicDesignTokens.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: IslamicDesignTokens.textPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
            children: [
              TextSpan(text: '${Strings.homeGreeting}, '),
              TextSpan(
                text: name,
                style: const TextStyle(
                  color: IslamicDesignTokens.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: IslamicDesignTokens.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              IslamicMockData.hijriDate,
              style: const TextStyle(
                color: IslamicDesignTokens.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: IslamicDesignTokens.textMuted,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                IslamicMockData.gregorianDate,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: IslamicDesignTokens.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PrayerTimesCard extends StatelessWidget {
  const _PrayerTimesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        color: IslamicDesignTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      IslamicMockData.nextPrayerLabel,
                      style: TextStyle(
                        color: IslamicDesignTokens.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      IslamicMockData.nextPrayerCountdown,
                      style: const TextStyle(
                        color: IslamicDesignTokens.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              _QiblaButton(),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(IslamicMockData.prayerTimes.length, (i) {
              final prayer = IslamicMockData.prayerTimes[i];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: i == IslamicMockData.prayerTimes.length - 1 ? 0 : 8,
                  ),
                  child: _PrayerPill(prayer: prayer),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _QiblaButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: IslamicDesignTokens.primary,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.explore_rounded,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                Strings.homeQibla,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrayerPill extends StatelessWidget {
  final PrayerTimeItem prayer;

  const _PrayerPill({required this.prayer});

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontSize: 12,
      fontWeight: prayer.isNext ? FontWeight.w700 : FontWeight.w500,
      color: prayer.isNext
          ? IslamicDesignTokens.textPrimary
          : IslamicDesignTokens.textSecondary,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(prayer.name, style: labelStyle),
        const SizedBox(height: 8),
        Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: prayer.isNext
                ? IslamicDesignTokens.primary
                : IslamicDesignTokens.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            prayer.time,
            style: TextStyle(
              color: prayer.isNext
                  ? Colors.white
                  : IslamicDesignTokens.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6),
        if (prayer.isNext)
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: IslamicDesignTokens.accent,
              shape: BoxShape.circle,
            ),
          )
        else
          const SizedBox(height: 6),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final ValueChanged<HomeQuickAction> onActionTap;

  const _QuickActionsGrid({required this.onActionTap});

  @override
  Widget build(BuildContext context) {
    final actions = IslamicMockData.homeQuickActions;
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.9,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: actions
          .map((a) => _QuickActionCard(
                action: a,
                onTap: () => onActionTap(a),
              ))
          .toList(),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final HomeQuickAction action;
  final VoidCallback onTap;

  const _QuickActionCard({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: IslamicDesignTokens.surface,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: IslamicDesignTokens.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  action.icon,
                  color: IslamicDesignTokens.primary,
                  size: 22,
                ),
              ),
              const Spacer(),
              Text(
                action.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: IslamicDesignTokens.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                action.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: IslamicDesignTokens.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
