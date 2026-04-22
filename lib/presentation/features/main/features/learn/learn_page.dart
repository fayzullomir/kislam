import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_app_bar.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_mock_data.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'learn_cubit.dart';

@RoutePage()
class LearnPage extends BasePage<LearnCubit, LearnState, LearnEvent> {
  const LearnPage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, LearnState state) {
    final course = IslamicMockData.learnCourse;
    return Scaffold(
      backgroundColor: IslamicDesignTokens.background,
      appBar: const IslamicAppBar(title: IslamicMockData.appTitle),
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _CourseIntro(course: course),
          const SizedBox(height: 20),
          _ProgressCard(course: course),
          const SizedBox(height: 28),
          _DaysTimeline(days: course.days),
        ],
      ),
    );
  }
}

class _CourseIntro extends StatelessWidget {
  final LearnCourseMock course;

  const _CourseIntro({required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.title,
          style: const TextStyle(
            color: IslamicDesignTokens.textPrimary,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          course.description,
          style: const TextStyle(
            color: IslamicDesignTokens.textSecondary,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final LearnCourseMock course;

  const _ProgressCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final percent = (course.progress * 100).round();
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        color: IslamicDesignTokens.surface,
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusLg),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Opacity(
              opacity: 0.3,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 110,
                color: IslamicDesignTokens.accentSoft,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.learnCurrentProgress,
                style: const TextStyle(
                  color: IslamicDesignTokens.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Strings.learnDaysCompleted(
                      course.completedDays.toString(),
                      course.totalDays.toString(),
                    ),
                    style: const TextStyle(
                      color: IslamicDesignTokens.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      '$percent%',
                      style: const TextStyle(
                        color: IslamicDesignTokens.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: course.progress,
                  minHeight: 10,
                  backgroundColor: IslamicDesignTokens.surfaceMuted,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    IslamicDesignTokens.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DaysTimeline extends StatelessWidget {
  final List<LearnDayMock> days;

  const _DaysTimeline({required this.days});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(days.length, (i) {
        final day = days[i];
        final isLast = i == days.length - 1;
        return _DayTimelineTile(
          day: day,
          isLast: isLast,
        );
      }),
    );
  }
}

class _DayTimelineTile extends StatelessWidget {
  final LearnDayMock day;
  final bool isLast;

  const _DayTimelineTile({required this.day, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimelineColumn(isCompleted: day.isCompleted, isLast: isLast),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: _DayCard(day: day),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineColumn extends StatelessWidget {
  final bool isCompleted;
  final bool isLast;

  const _TimelineColumn({required this.isCompleted, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isCompleted
                ? IslamicDesignTokens.primary
                : IslamicDesignTokens.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted
                  ? IslamicDesignTokens.primary
                  : IslamicDesignTokens.divider,
              width: 2,
            ),
          ),
          child: Icon(
            isCompleted ? Icons.check_rounded : Icons.lock_outline_rounded,
            color: isCompleted
                ? Colors.white
                : IslamicDesignTokens.textMuted,
            size: 18,
          ),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              color: IslamicDesignTokens.divider,
            ),
          ),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  final LearnDayMock day;

  const _DayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final label = Strings.learnDayLabel(day.day.toString().padLeft(2, '0'));
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: IslamicDesignTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: IslamicDesignTokens.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              _StatusPill(isCompleted: day.isCompleted),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            day.title,
            style: const TextStyle(
              color: IslamicDesignTokens.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            day.description,
            style: const TextStyle(
              color: IslamicDesignTokens.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isCompleted;

  const _StatusPill({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final label = isCompleted ? Strings.learnStatusCompleted : Strings.learnStatusLocked;
    final bg = isCompleted
        ? IslamicDesignTokens.surface
        : IslamicDesignTokens.divider;
    final fg = isCompleted
        ? IslamicDesignTokens.primary
        : IslamicDesignTokens.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
