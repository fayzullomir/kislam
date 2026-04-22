import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/data/repositories/auth/session_repository.dart';
import 'package:koreaislam/domain/models/session/active_session.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';
import 'package:koreaislam/presentation/support/extensions/extension_message_exts.dart';

part 'active_session_list_cubit.freezed.dart';
part 'active_session_list_state.dart';

@injectable
class ActiveSessionListCubit
    extends BaseCubit<ActiveSessionListState, ActiveSessionListEvent> {
  static const _pageSize = 10;
  final SessionRepository _sessionRepository;

  ActiveSessionListCubit(
    this._sessionRepository,
  ) : super(ActiveSessionListState()) {
    _initController();
  }

  @override
  Future<void> close() {
    states.controller?.dispose();
    return super.close();
  }

  void _initController() {
    final controller = PagingController<int, ActiveSession>(firstPageKey: 1);
    controller.addPageRequestListener(_fetchPage);
    updateState((state) => state.copyWith(controller: controller));
  }

  Future<void> _fetchPage(int pageKey) async {
    _sessionRepository
        .fetchActiveSessions(page: pageKey, size: _pageSize)
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

  void terminateSession(ActiveSession session) async {
    _sessionRepository
        .terminateSession(session)
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(terminatingSession: session));
        })
        .onSuccess((data) {
          if (data.isTerminated) {
            final list = List<ActiveSession>.from(states.controller?.itemList ?? []);
            list.removeWhere((e) => e.id == session.id);
            states.controller?.itemList = list;

            updateState((state) => state.copyWith(terminatingSession: null));
            emitEvent(ActiveSessionListEvent(OnSessionTerminated(
              sessionId: session.id,
            )));
          } else {
            updateState((state) => state.copyWith(terminatingSession: null));
            String message = data.hasMessage
                ? data.message!
                : Strings.activeSessionsTerminateError;
            stateMessageManager.showErrorBottomSheet(message);
          }
        })
        .onError((error) {
          updateState((state) => state.copyWith(terminatingSession: null));
          stateMessageManager.showErrorBottomSheet(error.localizedMessage);
        })
        .onFinished(() {})
        .executeFuture();
  }
}
