import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/data/datasource/preference/quran_translation_preferences.dart';
import 'package:koreaislam/domain/models/quran/quran_translation.dart';
import 'package:koreaislam/presentation/application/di/get_it_injection.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_sheet.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

/// Bottom sheet that lets the user pick a Quran translation. Reads +
/// writes through [QuranTranslationPreferences] — same Cubit-less,
/// notifier-driven pattern used by [MadhabSheet].
class QuranTranslationSheet extends StatefulWidget {
  const QuranTranslationSheet({super.key});

  @override
  State<QuranTranslationSheet> createState() => _QuranTranslationSheetState();
}

class _QuranTranslationSheetState extends State<QuranTranslationSheet> {
  final QuranTranslationPreferences _prefs =
      getIt<QuranTranslationPreferences>();
  late QuranTranslation _selected = _prefs.translation;

  @override
  Widget build(BuildContext context) {
    return NoorSheetScaffold(
      children: [
        NoorSheetHeader(
          eyebrow: Strings.quranTranslationSheetEyebrow,
          subtitle: Strings.quranTranslationSheetSubtitle,
        ),
        const SizedBox(height: 8),
        Container(
          color: context.noor.surface,
          child: Column(
            children: [
              for (var i = 0; i < QuranTranslation.values.length; i++) ...[
                NoorSheetSelectableRow(
                  title: QuranTranslation.values[i].translatorName,
                  subtitle: QuranTranslation.values[i].language.localizedName,
                  selected: _selected == QuranTranslation.values[i],
                  onTap: () => _select(QuranTranslation.values[i]),
                ),
                if (i != QuranTranslation.values.length - 1)
                  const NoorSheetRowDivider(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _select(QuranTranslation translation) async {
    setState(() => _selected = translation);
    await _prefs.setTranslation(translation);
    if (mounted) Navigator.of(context).maybePop();
  }
}
