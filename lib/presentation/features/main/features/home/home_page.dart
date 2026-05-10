import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
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
    return Scaffold(
      backgroundColor: context.noor.neutral,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _NextPrayerHeroCard(),
              const SizedBox(height: 16),
              const _PrayerTimesRow(),
              const SizedBox(height: 28),
              const _TodayWisdomSection(),
              const SizedBox(height: 28),
              _QuickLinksSection(
                onLinkTap: (link) => _handleQuickLinkTap(context, link),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleQuickLinkTap(BuildContext context, HomeQuickLink link) {
    switch (link.id) {
      case HomeQuickLinkId.qibla:
        context.router.push(QiblaRoute());
        break;
      case HomeQuickLinkId.quran:
        context.tabsRouter.setActiveIndex(1);
        break;
      case HomeQuickLinkId.dua:
        // No dedicated route yet — surface inside Learn (Q&A) for now.
        context.tabsRouter.setActiveIndex(3);
        break;
      case HomeQuickLinkId.halalMap:
        context.tabsRouter.setActiveIndex(3);
        break;
    }
  }
}

// ---------------------------------------------------------------------------
// Hero: large sand "NEXT PRAYER" card with countdown + Arabic decoration.
// ---------------------------------------------------------------------------

class _NextPrayerHeroCard extends StatelessWidget {
  const _NextPrayerHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        color: context.noor.neutralSand,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Faded calligraphy "صلاة" in the top-right corner.
          Positioned(
            right: -10,
            top: -6,
            child: IgnorePointer(
              child: Text(
                IslamicMockData.nextPrayerArabicDecor,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontArabic,
                  fontSize: 96,
                  height: 1,
                  fontWeight: FontWeight.w400,
                  color: context.noor.secondary.withOpacity(0.18),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.homeNextPrayerLabel,
                style: context.noor.tEyebrow.copyWith(
                  color: context.noor.inkMuted,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    IslamicMockData.nextPrayerName,
                    style: TextStyle(
                      fontFamily: IslamicDesignTokens.fontDisplay,
                      fontSize: 32,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                      color: context.noor.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      IslamicMockData.nextPrayerNameArabic,
                      style: TextStyle(
                        fontFamily: IslamicDesignTokens.fontArabic,
                        fontSize: 22,
                        height: 1,
                        color: context.noor.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                IslamicMockData.nextPrayerCountdownClock,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontDisplay,
                  fontSize: 56,
                  height: 1.05,
                  fontWeight: FontWeight.w600,
                  color: context.noor.ink,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      IslamicMockData.nextPrayerStartsAt,
                      style: context.noor.tBodySm,
                    ),
                  ),
                  Text(
                    IslamicMockData.currentLocationLine,
                    style: context.noor.tBodySm,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5 prayer time chips. The "next" prayer is filled green; the rest are white
// pills with a hairline border and dark text.
// ---------------------------------------------------------------------------

class _PrayerTimesRow extends StatelessWidget {
  const _PrayerTimesRow();

  @override
  Widget build(BuildContext context) {
    final prayers = IslamicMockData.prayerTimes;
    return Row(
      children: List.generate(prayers.length, (i) {
        final p = prayers[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == prayers.length - 1 ? 0 : 8),
            child: _PrayerChip(prayer: p),
          ),
        );
      }),
    );
  }
}

class _PrayerChip extends StatelessWidget {
  final PrayerTimeItem prayer;

  const _PrayerChip({required this.prayer});

  @override
  Widget build(BuildContext context) {
    final bg = prayer.isNext
        ? context.noor.primary
        : context.noor.surface;
    final fg = prayer.isNext ? Colors.white : context.noor.ink;
    final labelFg = prayer.isNext
        ? Colors.white.withOpacity(0.85)
        : context.noor.inkMuted;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: prayer.isNext
              ? Colors.transparent
              : context.noor.line,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            prayer.name.toUpperCase(),
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontBody,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: labelFg,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            prayer.time,
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontDisplay,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Today's Wisdom — sage-tinted card with a Qur'anic quote.
// ---------------------------------------------------------------------------

class _TodayWisdomSection extends StatelessWidget {
  const _TodayWisdomSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.homeTodayWisdomLabel,
          style: context.noor.tEyebrow,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
          decoration: BoxDecoration(
            color: context.noor.neutralSage,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                IslamicMockData.todayWisdomQuote,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontDisplay,
                  fontSize: 22,
                  height: 1.32,
                  fontWeight: FontWeight.w600,
                  color: context.noor.ink,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                IslamicMockData.todayWisdomSource,
                style: context.noor.tBodySm,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Quick Links — 2-column grid of compact white cards.
// ---------------------------------------------------------------------------

class _QuickLinksSection extends StatelessWidget {
  final ValueChanged<HomeQuickLink> onLinkTap;

  const _QuickLinksSection({required this.onLinkTap});

  @override
  Widget build(BuildContext context) {
    final links = IslamicMockData.homeQuickLinks;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.homeQuickLinksLabel,
          style: context.noor.tEyebrow,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.45,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: links
              .map((l) => _QuickLinkCard(link: l, onTap: () => onLinkTap(l)))
              .toList(),
        ),
      ],
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final HomeQuickLink link;
  final VoidCallback onTap;

  const _QuickLinkCard({required this.link, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.noor.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                link.icon,
                color: context.noor.primary,
                size: 22,
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    link.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: IslamicDesignTokens.fontDisplay,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.noor.ink,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    link.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.noor.tBodySm.copyWith(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
