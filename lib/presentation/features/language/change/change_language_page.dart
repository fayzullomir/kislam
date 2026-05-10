import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/language/language.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_sheet.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

import 'change_language_cubit.dart';

@RoutePage()
class ChangeLanguagePage extends BasePage<ChangeLanguageCubit,
    ChangeLanguageState, ChangeLanguageEvent> {
  const ChangeLanguagePage({super.key});

  @override
  Widget onWidgetBuild(BuildContext context, ChangeLanguageState state) {
    final languages = Language.values;
    return NoorSheetScaffold(
      children: [
        NoorSheetHeader(
          eyebrow: Strings.languageSheetEyebrow,
          subtitle: Strings.languageSheetSubtitle,
        ),
        const SizedBox(height: 8),
        Container(
          color: context.noor.surface,
          child: Column(
            children: [
              for (var i = 0; i < languages.length; i++) ...[
                NoorSheetSelectableRow(
                  title: languages[i].localizedName,
                  selected: state.selectedLanguage == languages[i],
                  onTap: () => _selectLanguage(context, languages[i]),
                ),
                if (i != languages.length - 1) const NoorSheetRowDivider(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _selectLanguage(BuildContext context, Language language) {
    EasyLocalization.of(context)?.setLocale(language.locale);
    cubit(context).setSelectedLanguage(language);
    context.router.maybePop();
  }
}
