import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/language/language.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_outlined_button.dart';
import 'package:koreaislam/presentation/widgets/responsive/responsive_container.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

import 'set_language_cubit.dart';

@RoutePage()
class SetLanguagePage
    extends BasePage<SetLanguageCubit, SetLanguageState, SetLanguageEvent> {
  const SetLanguagePage({super.key});

  @override
  void onEventEmitted(BuildContext context, SetLanguageEvent event) {
    switch (event.type) {
      case SetLanguageEventType.onOpenIntroPage:
        context.router.replace(IntroRoute());
        break;
      case SetLanguageEventType.onOpenLoginPage:
        context.router.replace(MainRoute());
        break;
    }
  }

  @override
  Widget onWidgetBuild(BuildContext context, SetLanguageState state) {
    return Scaffold(
      backgroundColor: context.pageBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          SizedBox(height: 36),
          Strings.languageTitle.s(20).w(500),
          SizedBox(height: 8),
          Strings.languageSubTitle.s(12).w(400),
          Spacer(),
          ResponsiveContainer(
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: Language.values.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                var language = Language.values[index];
                return MaterialOutlinedButton(
                  text: language.localizedName,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    EasyLocalization.of(context)?.setLocale(language.locale);
                    cubit(context).setLanguage(language);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
