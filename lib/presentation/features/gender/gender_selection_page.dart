import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/gender/gender.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/platform_sizes.dart';
import 'package:koreaislam/presentation/widgets/action/selection_list_item.dart';
import 'package:koreaislam/presentation/widgets/bottom_sheet/bottom_sheet_title.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';

import 'gender_selection_cubit.dart';

@RoutePage()
class GenderSelectionPage extends BasePage<GenderSelectionCubit,
    GenderSelectionState, GenderSelectionEvent> {
  final Gender? initialGender;

  GenderSelectionPage({
    super.key,
    this.initialGender,
  });

  @override
  void onWidgetCreated(BuildContext context) {
    cubit(context).setInitialData(initialGender);
  }

  @override
  Widget onWidgetBuild(BuildContext context, GenderSelectionState state) {
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
              BottomSheetTitle(title: Strings.genderSelectionTitle),
              SizedBox(height: 14),
              _buildSuccessBody(context, state),
              SizedBox(height: defaultBottomPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessBody(BuildContext context, GenderSelectionState state) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Gender.values.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        var gender = Gender.values[index];
        return SelectionListItem(
          item: gender,
          title: gender.localizedName,
          selected: state.selectedGender == gender,
          onClicked: (item) {
            cubit(context).setSelectedGender(gender);
            context.router.maybePop();
          },
        );
      },
    );
  }
}
