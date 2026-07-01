import 'dart:io';

import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/preference/prayer_notification_preferences.dart';
import 'package:koreaislam/domain/models/prayer/prayer_name.dart';
import 'package:koreaislam/domain/models/prayer_notification/prayer_notification_lead_time.dart';
import 'package:koreaislam/presentation/application/di/get_it_injection.dart';
import 'package:koreaislam/presentation/application/services/prayer/prayer_notification_scheduler.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_mock_data.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_sheet.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';
import 'package:permission_handler/permission_handler.dart';

/// Bottom sheet that hosts:
///   1. Per-prayer notification toggles (Fajr / Dhuhr / Asr / Maghrib / Isha)
///   2. The reminder lead-time radio (Instantly / 5 / 10 minutes before)
///   3. The daily-wisdom toggle (still local-only — wired in a follow-up)
///
/// Reads + writes through [PrayerNotificationPreferences]. Each write
/// goes back into the singleton notifier, which in turn triggers a
/// schedule rebuild via [PrayerNotificationScheduler]'s listener.
class NotificationSettingsSheet extends StatefulWidget {
  const NotificationSettingsSheet({super.key});

  @override
  State<NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState extends State<NotificationSettingsSheet> {
  final PrayerNotificationPreferences _prefs =
      getIt<PrayerNotificationPreferences>();
  final PrayerNotificationScheduler _scheduler =
      getIt<PrayerNotificationScheduler>();
  bool _dailyWisdomOn = false;

  /// Display order matches the home prayer-times row.
  static const _prayerOrder = [
    PrayerName.fajr,
    PrayerName.dhuhr,
    PrayerName.asr,
    PrayerName.maghrib,
    PrayerName.isha,
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PrayerNotificationSettings>(
      valueListenable: _prefs.notifier,
      builder: (_, settings, __) {
        return NoorSheetScaffold(
          children: [
            NoorSheetHeader(
              eyebrow: Strings.notificationsLabel,
              subtitle: settings.leadTime.localizedName,
            ),
            const SizedBox(height: 8),
            Container(
              color: context.noor.surface,
              child: Column(
                children: [
                  for (var i = 0; i < _prayerOrder.length; i++) ...[
                    _ToggleRow(
                      title: _prayerOrder[i].localizedName,
                      subtitle: _prayerSubtitle(_prayerOrder[i]),
                      value: settings.isEnabled(_prayerOrder[i]),
                      onChanged: (v) => _prefs.setPrayerEnabled(
                        _prayerOrder[i],
                        v,
                      ),
                    ),
                    if (i != _prayerOrder.length - 1)
                      const NoorSheetRowDivider(),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ----- Lead-time radio (Instantly / 5 min / 10 min) -----
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                Strings.notificationLeadTimeSection,
                style: context.noor.tEyebrow,
              ),
            ),
            Container(
              color: context.noor.surface,
              child: Column(
                children: [
                  for (var i = 0;
                      i < PrayerNotificationLeadTime.values.length;
                      i++) ...[
                    NoorSheetSelectableRow(
                      title:
                          PrayerNotificationLeadTime.values[i].localizedName,
                      selected: settings.leadTime ==
                          PrayerNotificationLeadTime.values[i],
                      onTap: () => _prefs.setLeadTime(
                        PrayerNotificationLeadTime.values[i],
                      ),
                    ),
                    if (i != PrayerNotificationLeadTime.values.length - 1)
                      const NoorSheetRowDivider(),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              color: context.noor.surface,
              child: _ToggleRow(
                title: Strings.dailyWisdom,
                subtitle: Strings.dailyWisdomTime,
                value: _dailyWisdomOn,
                onChanged: (v) => setState(() => _dailyWisdomOn = v),
              ),
            ),
            // ----- Notification permission recovery (all platforms) -----
            const SizedBox(height: 16),
            Container(
              color: context.noor.surface,
              child: _ActionRow(
                icon: Icons.notifications_active_rounded,
                title: Strings.permissionNotificationTitle,
                subtitle: Strings.permissionNotificationBody,
                onTap: _openNotificationPermission,
              ),
            ),
            // ----- Reliability shortcuts (Android only) -----
            if (Platform.isAndroid) ...[
              const SizedBox(height: 16),
              Container(
                color: context.noor.surface,
                child: Column(
                  children: [
                    _ActionRow(
                      icon: Icons.battery_charging_full_rounded,
                      title: Strings.permissionBatteryTitle,
                      subtitle: Strings.permissionBatteryBody,
                      onTap: _openBatteryOptimization,
                    ),
                    const NoorSheetRowDivider(),
                    _ActionRow(
                      icon: Icons.power_settings_new_rounded,
                      title: Strings.permissionAutostartTitle,
                      subtitle: Strings.permissionAutostartBody,
                      onTap: _openAutoStart,
                    ),
                  ],
                ),
              ),
            ],
            _buildDiagnostics(context),
          ],
        );
      },
    );
  }

  // TEMP diagnostics — release-visible scheduler trail + test trigger. Both
  // buttons wipe the previous trail before writing a fresh one so the log
  // always reflects a single run.
  Widget _buildDiagnostics(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Diagnostika', style: context.noor.tEyebrow),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _scheduler.rescheduleAll(),
                  child: const Text('Qayta rejalashtir'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _scheduler.fireTestNotification(),
                  child: const Text('Test (10s)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<List<String>>(
            valueListenable: _scheduler.diagnostics,
            builder: (_, lines, __) {
              return Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 260),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.noor.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    lines.isEmpty ? '— hali yozuv yo\'q —' : lines.join('\n'),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Recovery path for a user who denied notifications during onboarding:
  /// request again when possible, otherwise drop them on the OS settings
  /// page. A fresh grant reschedules immediately so the previously no-op'd
  /// prayer alarms actually land.
  Future<void> _openNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        if (result.isGranted) {
          await _scheduler.rescheduleAll();
          return;
        }
      }
      await openAppSettings();
    } catch (e, s) {
      AppLog.e('❌ notification permission request failed',
          error: e, stackTrace: s);
    }
  }

  Future<void> _openBatteryOptimization() async {
    try {
      await Permission.ignoreBatteryOptimizations.request();
    } catch (e, s) {
      AppLog.e('❌ battery-opt request failed', error: e, stackTrace: s);
    }
  }

  Future<void> _openAutoStart() async {
    try {
      final available = await isAutoStartAvailable;
      if (available == true) {
        await getAutoStartPermission();
      } else {
        // Stock Android / unsupported OEM — fall back to the app-info
        // page so the user can still toggle "Allow background activity".
        await openAppInfo();
      }
    } catch (e, s) {
      AppLog.e('❌ autostart open failed', error: e, stackTrace: s);
    }
  }

  /// Reuses the static prayer subtitles (Tong, Peshin, …) from the mock
  /// data — they're already localized via Strings.
  String _prayerSubtitle(PrayerName prayer) {
    final mock = IslamicMockData.prayerNotifications;
    switch (prayer) {
      case PrayerName.fajr:
        return mock[0].subtitle;
      case PrayerName.dhuhr:
        return mock[1].subtitle;
      case PrayerName.asr:
        return mock[2].subtitle;
      case PrayerName.maghrib:
        return mock[3].subtitle;
      case PrayerName.isha:
        return mock[4].subtitle;
      case PrayerName.sunrise:
        return '';
    }
  }
}

/// Tappable settings row with an icon + title + subtitle + chevron. Used
/// by the Android-only "Battery optimization" / "Auto-start" shortcuts
/// so the user can re-trigger the same prompts shown in onboarding.
class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: context.noor.primary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: IslamicDesignTokens.fontDisplay,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.noor.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.noor.tBodySm,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              color: context.noor.inkSoft,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: IslamicDesignTokens.fontDisplay,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: context.noor.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: context.noor.tBodySm),
              ],
            ),
          ),
          NoorSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
