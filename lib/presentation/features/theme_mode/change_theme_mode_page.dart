import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/theme/app_theme_mode.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/platform_sizes.dart';
import 'package:koreaislam/presentation/widgets/action/selection_list_item.dart';
import 'package:koreaislam/presentation/widgets/bottom_sheet/bottom_sheet_title.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

import 'change_theme_mode_cubit.dart';

@RoutePage()
class ChangeThemeModePage extends BasePage<ChangeThemeModeCubit,
    ChangeThemeModeState, ChangeThemeModeEvent> {
  const ChangeThemeModePage({super.key});

  @override
  Widget onWidgetBuild(BuildContext context, ChangeThemeModeState state) {
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
              BottomSheetTitle(title: Strings.changeThemeModeTitle),
              SizedBox(height: 14),
              _buildSuccessBody(context, state),
              SizedBox(height: defaultBottomPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessBody(BuildContext context, ChangeThemeModeState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildThemeModeItem(context, state, AppThemeMode.lightMode),
        SizedBox(height: 12),
        _buildThemeModeItem(context, state, AppThemeMode.darkMode),
        SizedBox(height: 12),
        _buildThemeModeItem(context, state, AppThemeMode.followSystem),
        SizedBox(height: 32)
      ],
    );
  }

  Widget _buildThemeModeItem(
    BuildContext context,
    ChangeThemeModeState state,
    AppThemeMode appThemeMode,
  ) {
    return SelectionListItem(
      item: appThemeMode,
      title: appThemeMode.localizedName,
      selected: state.appThemeMode == appThemeMode,
      onClicked: (item) {
        cubit(context).setSelectedThemeMode(item);
        context.router.maybePop();
      },
    );
  }
}
