import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/theme/app_theme_mode.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_sheet.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

import 'change_theme_mode_cubit.dart';

@RoutePage()
class ChangeThemeModePage extends BasePage<ChangeThemeModeCubit,
    ChangeThemeModeState, ChangeThemeModeEvent> {
  const ChangeThemeModePage({super.key});

  // Order picked to mirror the new design — Light first, then Dark, then
  // the system-follow option below.
  static const List<AppThemeMode> _order = [
    AppThemeMode.lightMode,
    AppThemeMode.darkMode,
    AppThemeMode.followSystem,
  ];

  @override
  Widget onWidgetBuild(BuildContext context, ChangeThemeModeState state) {
    return NoorSheetScaffold(
      children: [
        NoorSheetHeader(
          eyebrow: Strings.themeSheetEyebrow,
          subtitle: Strings.themeSheetSubtitle,
        ),
        const SizedBox(height: 8),
        Container(
          color: context.noor.surface,
          child: Column(
            children: [
              for (var i = 0; i < _order.length; i++) ...[
                NoorSheetSelectableRow(
                  title: _order[i].localizedName,
                  selected: state.appThemeMode == _order[i],
                  onTap: () => _selectMode(context, _order[i]),
                ),
                if (i != _order.length - 1) const NoorSheetRowDivider(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _selectMode(BuildContext context, AppThemeMode mode) {
    cubit(context).setSelectedThemeMode(mode);
    context.router.maybePop();
  }
}
