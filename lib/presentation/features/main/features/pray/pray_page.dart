import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/namaz_mock_data.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'pray_cubit.dart';

/// Namoz tab — list of all prayer types with rakat-count variant chips.
/// Tapping a chip pushes the step-by-step `NamazDetailPage` for that
/// prayer + variant.
///
/// Replaces the previous single-prayer step viewer; that flow now lives
/// inside `NamazDetailPage` and is reached via the variant chip.
@RoutePage()
class PrayPage extends BasePage<PrayCubit, PrayState, PrayEvent> {
  const PrayPage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, PrayState state) {
    final localeCode = context.locale.languageCode;
    final n = context.noor;
    return Scaffold(
      backgroundColor: n.neutral,
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(Strings.namazEyebrow, style: n.tEyebrow),
            ),
            const SizedBox(height: 4),
            Text(
              Strings.namazTitle,
              style: n.tDisplay.copyWith(
                fontSize: 30,
                letterSpacing: -0.8,
                height: 1.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Strings.namazSubtitle,
              style: TextStyle(
                fontFamily: IslamicDesignTokens.fontBody,
                color: n.inkSoft,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(height: 18),
            for (int i = 0; i < NamazMockData.all.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: i == NamazMockData.all.length - 1 ? 0 : 12,
                ),
                child: _NamazListCard(
                  namaz: NamazMockData.all[i],
                  localeCode: localeCode,
                  onVariantTap: (variant) {
                    context.router.push(
                      NamazDetailRoute(
                        namazId: NamazMockData.all[i].id,
                        variantId: variant.id,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single prayer card — name + time + arabic on top, rakat chips below.
// ---------------------------------------------------------------------------

class _NamazListCard extends StatelessWidget {
  final NamazMock namaz;
  final String localeCode;
  final ValueChanged<NamazVariant> onVariantTap;

  const _NamazListCard({
    required this.namaz,
    required this.localeCode,
    required this.onVariantTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: n.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: n.line, width: 0.5),
      ),
      child: Column(
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
                      namaz.localized(localeCode),
                      style: TextStyle(
                        fontFamily: IslamicDesignTokens.fontDisplay,
                        color: n.ink,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      namaz.timeLocalized(localeCode),
                      style: TextStyle(
                        fontFamily: IslamicDesignTokens.fontBody,
                        color: n.inkSoft,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                namaz.arabic,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontArabic,
                  color: n.secondaryInk,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final variant in namaz.variants)
                _VariantChip(
                  variant: variant,
                  localeCode: localeCode,
                  onTap: () => onVariantTap(variant),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VariantChip extends StatelessWidget {
  final NamazVariant variant;
  final String localeCode;
  final VoidCallback onTap;

  const _VariantChip({
    required this.variant,
    required this.localeCode,
    required this.onTap,
  });

  Color _backgroundFor(NoorTokens n) {
    switch (variant.kind) {
      case NamazVariantKind.farz:
        return n.primary;
      case NamazVariantKind.janoza:
        return n.secondary;
      case NamazVariantKind.sunnat:
      case NamazVariantKind.vitr:
      case NamazVariantKind.nafl:
        return n.primaryWash;
    }
  }

  Color _foregroundFor(NoorTokens n) {
    switch (variant.kind) {
      case NamazVariantKind.farz:
        return Colors.white;
      case NamazVariantKind.janoza:
        return Colors.white;
      case NamazVariantKind.sunnat:
      case NamazVariantKind.vitr:
      case NamazVariantKind.nafl:
        return n.ink;
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final bg = _backgroundFor(n);
    final fg = _foregroundFor(n);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                variant.localized(localeCode),
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontBody,
                  color: fg,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                color: fg.withOpacity(0.75),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
