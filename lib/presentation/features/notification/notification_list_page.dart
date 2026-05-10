import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/notification/app_notification.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/app_bar/default_app_bar.dart';
import 'package:koreaislam/presentation/widgets/notification/app_notification_shimmer.dart';
import 'package:koreaislam/presentation/widgets/notification/app_notification_widget.dart';
import 'package:koreaislam/presentation/widgets/scaffold/scrolling_scaffold.dart';
import 'package:koreaislam/presentation/widgets/state/default_empty_widget.dart';
import 'package:koreaislam/presentation/widgets/state/default_error_widget.dart';
import 'package:koreaislam/presentation/widgets/state/default_loading_widget.dart';

import 'notification_list_cubit.dart';

@RoutePage()
class NotificationListPage
    extends BasePage<NotificationListCubit, NotificationListState, NotificationListEvent> {
  const NotificationListPage({super.key});

  @override
  Widget onWidgetBuild(BuildContext context, NotificationListState state) {
    return ScrollingScaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, state),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return DefaultAppBar(
      title: Strings.commonNotifications,
      titleTextColor: context.textPrimary,
      backgroundColor: Colors.transparent,
      onBackPressed: () => context.router.popForced(),
    );
  }

  Widget _buildBody(BuildContext context, NotificationListState state) {
    if (state.controller == null) {
      return DefaultLoadingWidget(isFullScreen: true);
    }

    return RefreshIndicator(
      displacement: 80,
      strokeWidth: 3,
      color: StaticColors.colorAccent,
      onRefresh: () async => cubit(context).reloadData(),
      child: PagedListView<int, AppNotification>.separated(
        pagingController: state.controller!,
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 84, top: 16),
        separatorBuilder: (_, __) => SizedBox(height: 12),
        builderDelegate: PagedChildBuilderDelegate<AppNotification>(
          firstPageProgressIndicatorBuilder: (_) =>
              const _NotificationListLoading(),
          firstPageErrorIndicatorBuilder: (_) => DefaultErrorWidget(
            isFullScreen: true,
            onRetryClicked: () => cubit(context).reloadData(),
          ),
          noItemsFoundIndicatorBuilder: (_) => DefaultEmptyWidget(
            isFullScreen: true,
            message: Strings.commonEmptyMessage,
            icon: Assets.images.notificationListPageGroupEmpty
                .svg(width: 180, height: 170),
            onReloadClicked: () => cubit(context).reloadData(),
          ),
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
          itemBuilder: (context, notification, index) => AppNotificationWidget(
            notification: notification,
          ),
        ),
      ),
    );
  }
}

class _NotificationListLoading extends StatelessWidget {
  const _NotificationListLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: 7,
      itemBuilder: (context, index) {
        return AppNotificationShimmer();
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 12);
      },
    );
  }
}
