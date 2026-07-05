import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/data/datasource/preference/app_config_preferences.dart';
import 'package:koreaislam/data/datasource/preference/madhab_preferences.dart';
import 'package:koreaislam/domain/models/madhab/madhab.dart';
import 'package:koreaislam/presentation/application/di/get_it_injection.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_sheet.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

/// Onboarding-flow madhab picker — full page Noor styling. Mirrors the
/// existing [MadhabSheet] (used from Profile) but adds an explicit
/// "continue" step so the user confirms before moving on. Reads / writes
/// the same singleton [MadhabPreferences] so any other listener (e.g.
/// profile rows) stays in sync.
@RoutePage()
class MadhabSelectionPage extends StatefulWidget {
  const MadhabSelectionPage({super.key});

  @override
  State<MadhabSelectionPage> createState() => _MadhabSelectionPageState();
}

class _MadhabSelectionPageState extends State<MadhabSelectionPage> {
  final MadhabPreferences _prefs = getIt<MadhabPreferences>();
  final AppConfigPreferences _appConfigPrefs = getIt<AppConfigPreferences>();
  late Madhab _selected = _prefs.madhab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.noor.neutral,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Strings.madhabSelectionEyebrow,
                      textAlign: TextAlign.center,
                      style: context.noor.tEyebrow,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Strings.madhabSelectionTitle,
                      textAlign: TextAlign.center,
                      style: context.noor.tDisplay,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      Strings.madhabSelectionBody,
                      textAlign: TextAlign.center,
                      style: context.noor.tBody.copyWith(
                        color: context.noor.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      decoration: BoxDecoration(
                        color: context.noor.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.noor.line),
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < Madhab.values.length; i++) ...[
                            NoorSheetSelectableRow(
                              title: Madhab.values[i].localizedName,
                              selected: _selected == Madhab.values[i],
                              onTap: () => _select(Madhab.values[i]),
                            ),
                            if (i != Madhab.values.length - 1)
                              const NoorSheetRowDivider(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: _PrimaryButton(
                label: Strings.commonContinue,
                onTap: () => _onContinue(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _select(Madhab madhab) {
    HapticFeedback.lightImpact();
    setState(() => _selected = madhab);
  }

  Future<void> _onContinue(BuildContext context) async {
    await _prefs.setMadhab(_selected);
    await _appConfigPrefs.setIsMadhabSelected(true);
    if (!context.mounted) return;
    context.router.replace(LocationSelectionRoute());
  }
}

// ---------------------------------------------------------------------------

/// First-run-flow primary button — matches the one used by
/// [SetLanguagePage] / [LocationSelectionPage].
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.noor.primary,
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: IslamicDesignTokens.fontDisplay,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
