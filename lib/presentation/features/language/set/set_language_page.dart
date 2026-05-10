import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/language/language.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_sheet.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

import 'set_language_cubit.dart';

/// First-launch language picker. Same Noor layout as
/// [MadhabSelectionPage]: eyebrow + display title + body, a single
/// selectable card, and an explicit "continue" button at the bottom.
/// Tapping a row updates the in-memory selection and previews the locale
/// live; only "continue" persists the choice and triggers navigation.
@RoutePage()
class SetLanguagePage
    extends BasePage<SetLanguageCubit, SetLanguageState, SetLanguageEvent> {
  const SetLanguagePage({super.key});

  @override
  void onEventEmitted(BuildContext context, SetLanguageEvent event) {
    switch (event.type) {
      case SetLanguageEventType.onOpenOnboardingPage:
        context.router.replace(OnboardingRoute());
        break;
      case SetLanguageEventType.onOpenLoginPage:
        context.router.replace(MainRoute());
        break;
    }
  }

  @override
  Widget onWidgetBuild(BuildContext context, SetLanguageState state) {
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
                      Strings.languageSheetEyebrow,
                      textAlign: TextAlign.center,
                      style: context.noor.tEyebrow,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Strings.languageTitle,
                      textAlign: TextAlign.center,
                      style: context.noor.tDisplay,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      Strings.languageSubTitle,
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
                          for (var i = 0; i < Language.values.length; i++) ...[
                            NoorSheetSelectableRow(
                              title: Language.values[i].localizedName,
                              selected: state.language == Language.values[i],
                              onTap: () =>
                                  _onSelect(context, Language.values[i]),
                            ),
                            if (i != Language.values.length - 1)
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
                onTap: () => cubit(context).confirm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelect(BuildContext context, Language language) {
    HapticFeedback.lightImpact();
    EasyLocalization.of(context)?.setLocale(language.locale);
    cubit(context).setSelected(language);
  }
}

// ---------------------------------------------------------------------------

/// Onboarding-flow primary button — matches the one used by
/// [MadhabSelectionPage] / [LocationSelectionPage].
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
