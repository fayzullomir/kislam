import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/language/language.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/platform_sizes.dart';
import 'package:koreaislam/presentation/widgets/action/selection_list_item.dart';
import 'package:koreaislam/presentation/widgets/bottom_sheet/bottom_sheet_title.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

import 'change_language_cubit.dart';

@RoutePage()
class ChangeLanguagePage extends BasePage<ChangeLanguageCubit,
    ChangeLanguageState, ChangeLanguageEvent> {
  const ChangeLanguagePage({super.key});

  @override
  Widget onWidgetBuild(BuildContext context, ChangeLanguageState state) {
    return Material(
      child: Container(
        color: context.bottomSheetColor,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              BottomSheetTitle(title: Strings.languageTitle),
              SizedBox(height: 14),
              _buildSuccessBody(context, state),
              SizedBox(height: defaultBottomPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessBody(BuildContext context, ChangeLanguageState state) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Language.values.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        var language = Language.values[index];
        return SelectionListItem(
          item: language,
          title: language.localizedName,
          selected: state.selectedLanguage == language,
          onClicked: (item) {
            _saveSelectedLanguage(context, item);
            context.router.maybePop();
          },
        );
      },
    );
  }

  void _saveSelectedLanguage(BuildContext context, Language language) {
    Locale locale = language.locale;
    EasyLocalization.of(context)?.setLocale(locale);
    cubit(context).setSelectedLanguage(language);
  }
}
