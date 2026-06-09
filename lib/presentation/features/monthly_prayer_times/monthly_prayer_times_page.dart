import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/prayer/daily_prayer_times.dart';
import 'package:koreaislam/presentation/features/monthly_prayer_times/monthly_prayer_times_localization.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'monthly_prayer_times_cubit.dart';

/// Monthly prayer-time calendar — opened from the Home "Oylik taqvim"
/// quick link. Shows a navigable month table of the five obligatory
/// prayers plus sunrise, computed for the user's saved location.
@RoutePage()
class MonthlyPrayerTimesPage extends BasePage<MonthlyPrayerTimesCubit,
    MonthlyPrayerTimesState, MonthlyPrayerTimesEvent> {
  const MonthlyPrayerTimesPage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, MonthlyPrayerTimesState state) {
    final n = context.noor;
    return Scaffold(
      backgroundColor: n.neutral,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Text(
                    state.city.isNotEmpty
                        ? Strings.monthlyPrayerTimesTitleFormat(state.city)
                        : Strings.monthlyPrayerTimesTitleNoCity,
                    style: context.noor.tDisplay.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 16),
                  _ArabicDivider(),
                  const SizedBox(height: 16),
                  Text(
                    state.hasLocation
                        ? Strings.monthlyPrayerTimesDescription
                        : Strings.monthlyPrayerTimesNoLocation,
                    style: context.noor.tBodySm,
                  ),
                  const SizedBox(height: 20),
                  _MonthSelector(state: state, page: this),
                  const SizedBox(height: 14),
                  if (state.hasLocation) _MonthlyPrayerTimesTable(state: state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
      child: Row(
        children: [
          InkResponse(
            onTap: () => Navigator.of(context).maybePop(),
            radius: 22,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.chevron_left_rounded, color: n.ink, size: 26),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            Strings.monthlyPrayerTimesAppBarTitle,
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontDisplay,
              color: n.ink,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Thin gold rule with a faded "صلاة" calligraphy mark, mirroring the
/// concept header decoration.
class _ArabicDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Row(
      children: [
        Text(
          'صلاة',
          style: TextStyle(
            fontFamily: IslamicDesignTokens.fontArabic,
            fontSize: 22,
            height: 1,
            color: n.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(height: 1, color: n.secondary.withOpacity(0.4)),
        ),
      ],
    );
  }
}

class _MonthSelector extends StatelessWidget {
  final MonthlyPrayerTimesState state;
  final MonthlyPrayerTimesPage page;

  const _MonthSelector({required this.state, required this.page});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final label =
        '${MonthlyPrayerTimesLocalization.monthName(state.month.month)} ${state.month.year}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _NavButton(
          icon: Icons.chevron_left_rounded,
          onTap: () => page.cubit(context).previousMonth(),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: IslamicDesignTokens.fontDisplay,
            color: n.ink,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        _NavButton(
          icon: Icons.chevron_right_rounded,
          onTap: () => page.cubit(context).nextMonth(),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: n.inkMuted, size: 24),
      ),
    );
  }
}

class _MonthlyPrayerTimesTable extends StatelessWidget {
  final MonthlyPrayerTimesState state;

  const _MonthlyPrayerTimesTable({required this.state});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: n.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: n.line, width: 1),
      ),
      child: Column(
        children: [
          const _TableHeader(),
          for (var i = 0; i < state.days.length; i++)
            _TableRow(
              day: i + 1,
              times: state.days[i],
              isToday: state.todayDay == i + 1,
              isPast: state.todayDay != null && i + 1 < state.todayDay!,
              isLast: i == state.days.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final headers = [
      Strings.monthlyPrayerTimesColDay,
      Strings.prayerFajr,
      Strings.prayerSunrise,
      Strings.prayerDhuhr,
      Strings.prayerAsr,
      Strings.prayerMaghrib,
      Strings.prayerIsha,
    ];
    return Container(
      color: n.primary,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          for (var i = 0; i < headers.length; i++)
            Expanded(
              flex: i == 0 ? 2 : 3,
              child: Text(
                headers[i].toUpperCase(),
                textAlign: i == 0 ? TextAlign.center : TextAlign.center,
                style: const TextStyle(
                  fontFamily: IslamicDesignTokens.fontBody,
                  color: Colors.white,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final int day;
  final DailyPrayerTimes? times;
  final bool isToday;
  final bool isPast;
  final bool isLast;

  static final DateFormat _timeFormat = DateFormat('HH:mm');

  const _TableRow({
    required this.day,
    required this.times,
    required this.isToday,
    required this.isPast,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final fg = isToday
        ? n.ink
        : isPast
            ? n.inkSoft
            : n.ink;
    final weight = isToday ? FontWeight.w700 : FontWeight.w500;

    final cells = <String>[
      '$day',
      _fmt(times?.fajr),
      _fmt(times?.sunrise),
      _fmt(times?.dhuhr),
      _fmt(times?.asr),
      _fmt(times?.maghrib),
      _fmt(times?.isha),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isToday ? n.secondaryWash : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: isToday ? n.secondary : Colors.transparent,
            width: 3,
          ),
          bottom: BorderSide(
            color: isLast ? Colors.transparent : n.line,
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          for (var i = 0; i < cells.length; i++)
            Expanded(
              flex: i == 0 ? 2 : 3,
              child: Text(
                cells[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: i == 0
                      ? IslamicDesignTokens.fontDisplay
                      : IslamicDesignTokens.fontBody,
                  color: fg,
                  fontSize: i == 0 ? 13 : 12,
                  fontWeight: weight,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _fmt(DateTime? time) => time == null ? '—' : _timeFormat.format(time);
}
