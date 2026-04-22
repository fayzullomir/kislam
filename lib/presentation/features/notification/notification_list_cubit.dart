import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/data/repositories/notification/notification_repository.dart';
import 'package:koreaislam/domain/models/notification/app_notification.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'notification_list_cubit.freezed.dart';
part 'notification_list_state.dart';

@injectable
class NotificationListCubit
    extends BaseCubit<NotificationListState, NotificationListEvent> {
  static const _pageSize = 20;
  final NotificationRepository _notificationRepository;

  NotificationListCubit(
    this._notificationRepository,
  ) : super(const NotificationListState()) {
    _initController();
  }

  @override
  Future<void> close() {
    states.controller?.dispose();
    return super.close();
  }

  void _initController() {
    final controller = PagingController<int, AppNotification>(firstPageKey: 1);
    controller.addPageRequestListener(_fetchAppNotifications);
    updateState((state) => state.copyWith(controller: controller));
  }

  Future<void> _fetchAppNotifications(int pageKey) async {
    _notificationRepository
        .fetchAppNotifications(page: pageKey, size: _pageSize)
        .initFuture()
        .onStart(() {})
        .onSuccess((data) {
          if (data.length < _pageSize) {
            states.controller?.appendLastPage(data);
          } else {
            states.controller?.appendPage(data, pageKey + 1);
          }
        })
        .onError((error) {
          states.controller?.error = error;
        })
        .onFinished(() {})
        .executeFuture();
  }

  void reloadData() {
    states.controller?.refresh();
  }
}
