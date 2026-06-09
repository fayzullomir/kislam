import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/prayer/prayer_name.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/library_mock_data.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_mock_data.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

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
              _NextPrayerHeroCard(state: state),
              const SizedBox(height: 16),
              _PrayerTimesRow(state: state),
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
      case HomeQuickLinkId.monthlyPrayerTimes:
        context.router.push(MonthlyPrayerTimesRoute());
        break;
      case HomeQuickLinkId.qadaTracker:
        context.router.push(QadaTrackerRoute());
        break;
      case HomeQuickLinkId.quran:
        context.router.push(
          BookReaderRoute(bookId: LibraryMockData.quranBookId),
        );
        break;
      case HomeQuickLinkId.dua:
        // No dedicated route yet — surface inside Learn (Q&A) for now.
        context.tabsRouter.setActiveIndex(3);
        break;
      case HomeQuickLinkId.halalMap:
        context.router.push(HalalMapRoute());
        break;
    }
  }
}

// ---------------------------------------------------------------------------
// Time formatters — kept at top-level so they are constructed once per
// build pass and shared by every widget below.
// ---------------------------------------------------------------------------

final DateFormat _timeFormatter = DateFormat('HH:mm');

/// hh:mm:ss countdown — drops the leading "0:" once under one hour so
/// the hero text doesn't look top-heavy in the home zone.
String _formatCountdown(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (h > 0) return '$h:$m:$s';
  return '$m:$s';
}

// ---------------------------------------------------------------------------
// Hero: large sand "NEXT PRAYER" card with countdown + Arabic decoration.
// ---------------------------------------------------------------------------

class _NextPrayerHeroCard extends StatelessWidget {
  final HomeState state;

  const _NextPrayerHeroCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final hasPrayer =
        state.nextPrayerName != null && state.nextPrayerTime != null;
    final prayerLabel =
        hasPrayer ? state.nextPrayerName!.localizedName : '—';
    final prayerArabic =
        hasPrayer ? _arabicNameFor(state.nextPrayerName!) : '';
    final countdownText = state.countdown != null
        ? _formatCountdown(state.countdown!)
        : '--:--';
    final startsAt = hasPrayer
        ? Strings.homeUntilFormat(_timeFormatter.format(state.nextPrayerTime!))
        : '';
    final locationText = state.locationLabel.isNotEmpty
        ? state.locationLabel
        : Strings.homeLocationUnknown;

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
                    prayerLabel,
                    style: TextStyle(
                      fontFamily: IslamicDesignTokens.fontDisplay,
                      fontSize: 32,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                      color: context.noor.primary,
                    ),
                  ),
                  if (prayerArabic.isNotEmpty) ...[
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        prayerArabic,
                        style: TextStyle(
                          fontFamily: IslamicDesignTokens.fontArabic,
                          fontSize: 22,
                          height: 1,
                          color: context.noor.secondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Text(
                countdownText,
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
                      startsAt,
                      style: context.noor.tBodySm,
                    ),
                  ),
                  Text(
                    locationText,
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

  /// Arabic glyph for each obligatory prayer — used as decorative label
  /// next to the localized name. Hard-coded since the script doesn't
  /// vary by user language.
  String _arabicNameFor(PrayerName prayer) {
    switch (prayer) {
      case PrayerName.fajr:
        return 'الفجر';
      case PrayerName.sunrise:
        return 'الشروق';
      case PrayerName.dhuhr:
        return 'الظهر';
      case PrayerName.asr:
        return 'العصر';
      case PrayerName.maghrib:
        return 'المغرب';
      case PrayerName.isha:
        return 'العشاء';
    }
  }
}

// ---------------------------------------------------------------------------
// 5 prayer time chips. The "next" prayer is filled green; the rest are white
// pills with a hairline border and dark text.
// ---------------------------------------------------------------------------

class _PrayerTimesRow extends StatelessWidget {
  final HomeState state;

  const _PrayerTimesRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final today = state.todayPrayers;
    final entries = today != null
        ? today.obligatoryPrayers
            .map((p) => _RowEntry(
                  name: p.name,
                  time: _timeFormatter.format(p.time),
                  isNext: p.name == state.nextPrayerName,
                ))
            .toList()
        : _placeholderEntries();

    return Row(
      children: List.generate(entries.length, (i) {
        final p = entries[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == entries.length - 1 ? 0 : 8),
            child: _PrayerChip(entry: p),
          ),
        );
      }),
    );
  }

  /// Used while [todayPrayers] is null (no GPS yet) so the row layout
  /// stays stable — same five labels, dashes for time.
  List<_RowEntry> _placeholderEntries() {
    return const [
      _RowEntry(name: PrayerName.fajr, time: '--:--', isNext: false),
      _RowEntry(name: PrayerName.dhuhr, time: '--:--', isNext: false),
      _RowEntry(name: PrayerName.asr, time: '--:--', isNext: false),
      _RowEntry(name: PrayerName.maghrib, time: '--:--', isNext: false),
      _RowEntry(name: PrayerName.isha, time: '--:--', isNext: false),
    ];
  }
}

class _RowEntry {
  final PrayerName name;
  final String time;
  final bool isNext;

  const _RowEntry({
    required this.name,
    required this.time,
    required this.isNext,
  });
}

class _PrayerChip extends StatelessWidget {
  final _RowEntry entry;

  const _PrayerChip({required this.entry});

  @override
  Widget build(BuildContext context) {
    final bg = entry.isNext ? context.noor.primary : context.noor.surface;
    final fg = entry.isNext ? Colors.white : context.noor.ink;
    final labelFg = entry.isNext
        ? Colors.white.withOpacity(0.85)
        : context.noor.inkMuted;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: entry.isNext ? Colors.transparent : context.noor.line,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            entry.name.localizedName.toUpperCase(),
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
            entry.time,
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

