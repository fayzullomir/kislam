import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/region/country.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/platform_sizes.dart';
import 'package:koreaislam/presentation/widgets/action/action_item_shimmer.dart';
import 'package:koreaislam/presentation/widgets/action/selection_list_item.dart';
import 'package:koreaislam/presentation/widgets/bottom_sheet/bottom_sheet_title.dart';
import 'package:koreaislam/presentation/widgets/state/default_empty_widget.dart';
import 'package:koreaislam/presentation/widgets/state/default_error_widget.dart';
import 'package:koreaislam/presentation/widgets/state/loader_state_widget.dart';

import 'country_selection_cubit.dart';

@RoutePage()
class CountrySelectionPage extends BasePage<CountrySelectionCubit,
    CountrySelectionState, CountrySelectionEvent> {
  final Country? initialCountry;

  const CountrySelectionPage({
    super.key,
    this.initialCountry,
  });

  @override
  void onWidgetCreated(BuildContext context) {
    cubit(context).setInitialData(initialCountry);
  }

  @override
  Widget onWidgetBuild(
    BuildContext context,
    CountrySelectionState state,
  ) {
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
              BottomSheetTitle(title: Strings.countrySelectionTitle),
              SizedBox(height: 14),
              LoaderStateWidget(
                isFullScreen: false,
                loadingState: state.countriesState,
                loadingBody: _buildLoadingBody(),
                successBody: _buildSuccessBody(context, state),
                emptyBody: DefaultEmptyWidget(isFullScreen: false),
                errorBody: DefaultErrorWidget(
                  isFullScreen: false,
                  onRetryClicked: () => cubit(context).reloadData(),
                ),
              ),
              SizedBox(height: defaultBottomPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingBody() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return ActionItemShimmer();
      },
      separatorBuilder: (BuildContext c, int index) => SizedBox(height: 12),
    );
  }

  Widget _buildSuccessBody(
    BuildContext context,
    CountrySelectionState state,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: state.countries.length,
      itemBuilder: (context, index) {
        var country = state.countries[index];
        return SelectionListItem(
          item: country,
          title: country.name,
          selected: state.selectedCountry == country,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          onClicked: (item) {
            cubit(context).setSelectedCountry(item);
            context.router.pop();
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12),
    );
  }
}
