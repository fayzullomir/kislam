import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/enum/enums.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/data/repositories/service/service_repository.dart';
import 'package:koreaislam/domain/models/service/service_type.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'quran_cubit.freezed.dart';
part 'quran_state.dart';

@injectable
class QuranCubit extends BaseCubit<QuranState, QuranEvent> {
  final ServiceRepository _serviceRepository;

  QuranCubit(this._serviceRepository) : super(QuranState()) {
    loadData();
  }

  void loadData() {
    fetchAvailableServices();
  }

  void reloadData() {
    fetchAvailableServices();
  }

  void fetchAvailableServices() {
    _serviceRepository
        .fetchAvailableServices()
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(
                servicesState: LoadingState.loading,
              ));
        })
        .onSuccess((data) {
          updateState((state) => state.copyWith(
                services: data,
                servicesState:
                    data.isEmpty ? LoadingState.empty : LoadingState.success,
              ));
        })
        .onError((error) {
          updateState((state) => state.copyWith(
                servicesState: LoadingState.error,
              ));
        })
        .onFinished(() {})
        .executeFuture();
  }
}
