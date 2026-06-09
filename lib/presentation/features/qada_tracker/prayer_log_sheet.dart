import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log_type.dart';
import 'package:koreaislam/domain/models/prayer/prayer_log_status.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_sheet.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/features/qada_tracker/prayer_log_visuals.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

/// "How did you pray?" sheet. Lets the user tag a prayer for the selected
/// day with one of the four statuses. Pops with the chosen [PrayerLogStatus]
/// (the caller persists it). Re-selecting the current status pops it too —
/// the cubit treats that as a toggle-off.
class PrayerLogSheet extends StatelessWidget {
  final PrayerLogType prayer;
  final PrayerLogStatus? currentStatus;
  final int remaining;

  const PrayerLogSheet({
    super.key,
    required this.prayer,
    required this.currentStatus,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return NoorSheetScaffold(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 12, 8),
          child: Row(
            children: [
              _IconBox(icon: PrayerLogVisuals.prayerIcon(prayer)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prayer.localizedName,
                      style: TextStyle(
                        fontFamily: IslamicDesignTokens.fontDisplay,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: n.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Strings.qadaTrackerSheetRemainingFormat('$remaining'),
                      style: context.noor.tBodySm,
                    ),
                  ],
                ),
              ),
              _CloseButton(onTap: () => Navigator.of(context).maybePop()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Text(
            Strings.qadaTrackerSheetQuestion,
            style: context.noor.tEyebrow,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              for (final status in PrayerLogStatus.values) ...[
                _StatusRow(
                  status: status,
                  selected: status == currentStatus,
                  onTap: () => Navigator.of(context).maybePop(status),
                ),
                if (status != PrayerLogStatus.values.last)
                  const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  final PrayerLogStatus status;
  final bool selected;
  final VoidCallback onTap;

  const _StatusRow({
    required this.status,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final color = PrayerLogVisuals.statusColor(context, status);
    return Material(
      color: selected ? color.withOpacity(0.12) : n.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? color : n.line,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  PrayerLogVisuals.statusIcon(status),
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  status.localizedName,
                  style: TextStyle(
                    fontFamily: IslamicDesignTokens.fontDisplay,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: n.ink,
                  ),
                ),
              ),
              SizedBox(
                width: 24,
                height: 24,
                child: selected
                    ? Icon(Icons.check_rounded, color: color, size: 22)
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: n.lineStrong, width: 1.6),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;

  const _IconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: n.neutralSage,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: n.ink, size: 24),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Material(
      color: n.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(Icons.close_rounded, color: n.inkMuted, size: 22),
        ),
      ),
    );
  }
}
