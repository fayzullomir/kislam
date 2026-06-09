import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log_type.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log_status.dart';
import 'package:koreaislam/presentation/features/monthly_prayer_times/monthly_prayer_times_localization.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/features/qada_tracker/prayer_log_sheet.dart';
import 'package:koreaislam/presentation/features/qada_tracker/prayer_log_visuals.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'qada_tracker_cubit.dart';

/// Qada (missed-prayer) make-up tracker — opened from the Home "Qada
/// namozlar" quick link. Shows the remaining backlog per prayer and lets
/// the user journal how each prayer was performed per day.
@RoutePage()
class QadaTrackerPage extends BasePage<QadaTrackerCubit, QadaTrackerState, QadaTrackerEvent> {
  const QadaTrackerPage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, QadaTrackerState state) {
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
                  _DayStrip(state: state, page: this),
                  const SizedBox(height: 18),
                  _SummaryCard(state: state),
                  const SizedBox(height: 22),
                  _SelectedDateRow(state: state),
                  const SizedBox(height: 12),
                  for (final prayer in PrayerLogType.values) ...[
                    _PrayerCard(
                      prayer: prayer,
                      remaining: state.missedFor(prayer),
                      status: state.statusFor(prayer),
                      onTap: () => _openStatusSheet(context, state, prayer),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openStatusSheet(
    BuildContext context,
    QadaTrackerState state,
    PrayerLogType prayer,
  ) async {
    final result = await showCupertinoModalBottomSheet<PrayerLogStatus>(
      context: context,
      backgroundColor: Colors.transparent,
      expand: false,
      builder: (_) => PrayerLogSheet(
        prayer: prayer,
        currentStatus: state.statusFor(prayer),
        remaining: state.missedFor(prayer),
      ),
    );
    if (result != null && context.mounted) {
      cubit(context).setStatus(prayer, result);
    }
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
            Strings.qadaTrackerAppBarTitle,
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

// ---------------------------------------------------------------------------
// Horizontal day selector — auto-scrolls to the selected (today) day.
// ---------------------------------------------------------------------------

class _DayStrip extends StatefulWidget {
  final QadaTrackerState state;
  final QadaTrackerPage page;

  const _DayStrip({required this.state, required this.page});

  @override
  State<_DayStrip> createState() => _DayStripState();
}

class _DayStripState extends State<_DayStrip> {
  static const double _itemWidth = 60;
  static const double _itemSpacing = 10;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  void _scrollToSelected() {
    if (!_controller.hasClients) return;
    final index =
        widget.state.days.indexWhere((d) => widget.state.isSelected(d));
    if (index < 0) return;
    final target = index * (_itemWidth + _itemSpacing) -
        (_controller.position.viewportDimension / 2) +
        _itemWidth / 2;
    _controller.jumpTo(
      target.clamp(0.0, _controller.position.maxScrollExtent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final today = DateTime.now();
    return SizedBox(
      height: 72,
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: state.days.length,
        separatorBuilder: (_, __) => const SizedBox(width: _itemSpacing),
        itemBuilder: (_, i) {
          final day = state.days[i];
          final isFuture = DateTime(day.year, day.month, day.day)
              .isAfter(DateTime(today.year, today.month, today.day));
          return _DayCard(
            width: _itemWidth,
            day: day,
            selected: state.isSelected(day),
            disabled: isFuture,
            onTap: isFuture
                ? null
                : () => widget.page.cubit(context).selectDate(day),
          );
        },
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final double width;
  final DateTime day;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  const _DayCard({
    required this.width,
    required this.day,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final bg = selected ? n.primary : n.surface;
    final labelColor = selected
        ? Colors.white.withOpacity(0.85)
        : disabled
            ? n.inkSoft
            : n.inkMuted;
    final dayColor = selected
        ? Colors.white
        : disabled
            ? n.inkSoft
            : n.ink;
    return SizedBox(
      width: width,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? Colors.transparent : n.line,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  MonthlyPrayerTimesLocalization.weekdayShort(day.weekday),
                  style: TextStyle(
                    fontFamily: IslamicDesignTokens.fontBody,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${day.day}',
                  style: TextStyle(
                    fontFamily: IslamicDesignTokens.fontDisplay,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: dayColor,
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

// ---------------------------------------------------------------------------
// Summary card — total remaining, completion %, progress bar.
// ---------------------------------------------------------------------------

class _SummaryCard extends StatelessWidget {
  final QadaTrackerState state;

  const _SummaryCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: n.neutralSand,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -6,
            top: -10,
            child: IgnorePointer(
              child: Text(
                'قضاء',
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontArabic,
                  fontSize: 64,
                  height: 1,
                  color: n.secondary.withOpacity(0.16),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Strings.qadaTrackerTotalRemainingLabel,
                          style: context.noor.tEyebrow,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${state.totalMissed}',
                              style: TextStyle(
                                fontFamily: IslamicDesignTokens.fontDisplay,
                                fontSize: 40,
                                height: 1,
                                fontWeight: FontWeight.w700,
                                color: n.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              Strings.qadaTrackerCountSuffix,
                              style: context.noor.tBodySm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${state.progressPercent}%',
                        style: TextStyle(
                          fontFamily: IslamicDesignTokens.fontDisplay,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: n.secondaryInk,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${state.totalMissed} / ${state.totalLogged}',
                        style: context.noor.tBodySm,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: state.progress,
                  minHeight: 8,
                  backgroundColor: n.lineStrong,
                  valueColor: AlwaysStoppedAnimation(n.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectedDateRow extends StatelessWidget {
  final QadaTrackerState state;

  const _SelectedDateRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final now = DateTime.now();
    final isToday = state.selectedDate.year == now.year &&
        state.selectedDate.month == now.month &&
        state.selectedDate.day == now.day;
    final dateLabel = '${state.selectedDate.day}-'
        '${MonthlyPrayerTimesLocalization.monthName(state.selectedDate.month).toLowerCase()}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isToday ? Strings.qadaTrackerTodayLabel : dateLabel,
          style: TextStyle(
            fontFamily: IslamicDesignTokens.fontDisplay,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: n.ink,
          ),
        ),
        if (isToday)
          Text(dateLabel, style: context.noor.tBodySm),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Prayer card — backlog count + today's logged status.
// ---------------------------------------------------------------------------

class _PrayerCard extends StatelessWidget {
  final PrayerLogType prayer;
  final int remaining;
  final PrayerLogStatus? status;
  final VoidCallback onTap;

  const _PrayerCard({
    required this.prayer,
    required this.remaining,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Material(
      color: n.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: n.neutralSage,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  PrayerLogVisuals.prayerIcon(prayer),
                  color: n.ink,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prayer.localizedName,
                      style: TextStyle(
                        fontFamily: IslamicDesignTokens.fontDisplay,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: n.ink,
                      ),
                    ),
                    if (status != null) ...[
                      const SizedBox(height: 4),
                      _Subtitle(status: status!),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$remaining',
                    style: TextStyle(
                      fontFamily: IslamicDesignTokens.fontDisplay,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: n.ink,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(Strings.qadaTrackerCountSuffix, style: context.noor.tCaption),
                ],
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: n.inkSoft, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  final PrayerLogStatus status;

  const _Subtitle({required this.status});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final color = PrayerLogVisuals.statusColor(context, status);
    return Row(
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            status.localizedName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: n.tBodySm.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
