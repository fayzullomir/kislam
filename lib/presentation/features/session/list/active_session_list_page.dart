import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:koreaislam/core/extensions/date_extensions.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/session/active_session.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/app_bar/default_app_bar.dart';
import 'package:koreaislam/presentation/widgets/divider/custom_divider.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:koreaislam/presentation/widgets/scaffold/scrolling_scaffold.dart';
import 'package:koreaislam/presentation/widgets/state/default_empty_widget.dart';
import 'package:koreaislam/presentation/widgets/state/default_error_widget.dart';
import 'package:koreaislam/presentation/widgets/state/default_loading_widget.dart';

import 'active_session_list_cubit.dart';

@RoutePage()
class ActiveSessionListPage extends BasePage<ActiveSessionListCubit,
    ActiveSessionListState, ActiveSessionListEvent> {
  const ActiveSessionListPage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, ActiveSessionListState state) {
    return ScrollingScaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, state),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return DefaultAppBar(
      title: Strings.activeSessionsTitle,
      onBackPressed: () => context.router.pop(),
    );
  }

  Widget _buildBody(BuildContext context, ActiveSessionListState state) {
    if (state.controller == null) {
      return DefaultLoadingWidget(isFullScreen: true);
    }

    return RefreshIndicator(
      displacement: 80,
      strokeWidth: 3,
      color: StaticColors.colorAccent,
      onRefresh: () async => cubit(context).reloadData(),
      child: PagedListView<int, ActiveSession>.separated(
        pagingController: state.controller!,
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: EdgeInsets.only(left: 12, top: 20, right: 12, bottom: 180),
        separatorBuilder: (_, __) => SizedBox(height: 8),
        builderDelegate: PagedChildBuilderDelegate<ActiveSession>(
          firstPageProgressIndicatorBuilder: (_) =>
              DefaultLoadingWidget(isFullScreen: true),
          firstPageErrorIndicatorBuilder: (_) => DefaultErrorWidget(
            isFullScreen: true,
            onRetryClicked: () => cubit(context).reloadData(),
          ),
          noItemsFoundIndicatorBuilder: (_) =>
              DefaultEmptyWidget(isFullScreen: true),
          newPageProgressIndicatorBuilder: (_) => Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: context.colorAccent),
            ),
          ),
          newPageErrorIndicatorBuilder: (_) => DefaultErrorWidget(
            isFullScreen: false,
            onRetryClicked: () => cubit(context).reloadData(),
          ),
          itemBuilder: (context, session, index) => _ActiveSessionItem(
            session: session,
            state: state,
            onTerminateTap: () => cubit(context).terminateSession(session),
          ),
        ),
      ),
    );
  }
}

class _ActiveSessionItem extends StatelessWidget {
  const _ActiveSessionItem({
    required this.session,
    required this.state,
    required this.onTerminateTap,
  });

  final ActiveSession session;
  final ActiveSessionListState state;
  final VoidCallback onTerminateTap;

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      borderRadius: BorderRadius.circular(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colorAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Assets.images.activeSessionListPageSessionDevicePhone
                      .svg(
                    color: context.colorAccent,
                  ),
                ),
                SizedBox(width: 14),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    session.deviceName.s(14).w(500).c(context.textPrimary),
                    SizedBox(height: 6),
                    session.createdAt
                        .toDateString(outputFormat: 'yyyy-MM-dd HH:mm:ss')
                        .toString()
                        .s(14)
                        .w(400)
                        .c(context.textSecondary),
                    if (session.isCurrentSession) ...[
                      SizedBox(height: 6),
                      Strings.activeSessionCurrentSession
                          .s(14)
                          .w(400)
                          .c(StaticColors.colorAccent),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (session.isNotCurrentSession) ...[
            CustomDivider(thickness: 1, startIndent: 12, endIndent: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  onTap: onTerminateTap,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          if (session.id == state.terminatingSession?.id)
                            SizedBox(width: 16),
                          Expanded(
                            child: Strings.activeSessionsTerminate
                                .s(14)
                                .w(400)
                                .c(StaticColors.toastErrorBackgroundColor)
                                .copyWith(textAlign: TextAlign.center),
                          ),
                          if (session.id == state.terminatingSession?.id)
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: StaticColors.toastErrorBackgroundColor,
                                strokeWidth: 1.5,
                                strokeAlign: 0.5,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ],
      ),
    );
  }
}
