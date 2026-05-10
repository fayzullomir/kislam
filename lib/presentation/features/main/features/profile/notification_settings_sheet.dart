import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_mock_data.dart';

/// Bottom sheet that hosts prayer-time notification toggles + the daily
/// wisdom reminder. Local state only — wire to a preferences repository
/// in a follow-up.
class NotificationSettingsSheet extends StatefulWidget {
  const NotificationSettingsSheet({super.key});

  @override
  State<NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState extends State<NotificationSettingsSheet> {
  late List<bool> _prayerToggles =
      IslamicMockData.prayerNotifications.map((p) => p.isOn).toList();
  bool _dailyWisdomOn = false;

  @override
  Widget build(BuildContext context) {
    final prayers = IslamicMockData.prayerNotifications;
    return Material(
      color: context.noor.neutral,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SheetHandle(),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Strings.notificationsLabel,
                        style: context.noor.tEyebrow),
                    const SizedBox(height: 6),
                    Text(
                      Strings.notificationsLeadTime,
                      style: context.noor.tBodySm,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                color: context.noor.surface,
                child: Column(
                  children: [
                    for (var i = 0; i < prayers.length; i++) ...[
                      _ToggleRow(
                        title: prayers[i].label,
                        subtitle: prayers[i].subtitle,
                        value: _prayerToggles[i],
                        onChanged: (v) =>
                            setState(() => _prayerToggles[i] = v),
                      ),
                      if (i != prayers.length - 1) const _RowDivider(),
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: context.noor.line,
            borderRadius: BorderRadius.circular(2),
          ),
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
          Switch.adaptive(
            value: value,
            activeColor: context.noor.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: context.noor.line,
      ),
    );
  }
}
