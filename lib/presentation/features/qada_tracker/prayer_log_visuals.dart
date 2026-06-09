import 'package:flutter/material.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log_type.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log_status.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';

/// Presentation-only mapping of qada domain enums onto icons and colors.
/// Kept out of the domain layer so the model stays UI-agnostic.
class PrayerLogVisuals {
  PrayerLogVisuals._();

  static IconData prayerIcon(PrayerLogType prayer) {
    switch (prayer) {
      case PrayerLogType.fajr:
        return Icons.wb_twilight_rounded;
      case PrayerLogType.dhuhr:
        return Icons.light_mode_rounded;
      case PrayerLogType.asr:
        return Icons.brightness_6_rounded;
      case PrayerLogType.maghrib:
        return Icons.brightness_4_rounded;
      case PrayerLogType.isha:
        return Icons.nights_stay_rounded;
      case PrayerLogType.vitr:
        return Icons.dark_mode_rounded;
    }
  }

  static IconData statusIcon(PrayerLogStatus status) {
    switch (status) {
      case PrayerLogStatus.jamoat:
        return Icons.groups_rounded;
      case PrayerLogStatus.onTime:
        return Icons.schedule_rounded;
      case PrayerLogStatus.late:
        return Icons.history_rounded;
      case PrayerLogStatus.missed:
        return Icons.do_not_disturb_rounded;
    }
  }

  static Color statusColor(BuildContext context, PrayerLogStatus status) {
    final n = context.noor;
    switch (status) {
      case PrayerLogStatus.jamoat:
        return n.primary;
      case PrayerLogStatus.onTime:
        return n.secondaryInk;
      case PrayerLogStatus.late:
        return n.warning;
      case PrayerLogStatus.missed:
        return n.danger;
    }
  }
}
