import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/enum/enums.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/data/repositories/guide/guide_repository.dart';
import 'package:koreaislam/domain/models/guide/guide_category.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'learn_cubit.freezed.dart';
part 'learn_state.dart';

@injectable
class LearnCubit extends BaseCubit<LearnState, LearnEvent> {
  final GuideRepository _guideRepository;

  LearnCubit(
    this._guideRepository,
  ) : super(LearnState()) {
    loadData();
  }

  loadData() {
    fetchGuideCategories();
  }

  reloadData() {
    fetchGuideCategories();
  }

  fetchGuideCategories() {
    _guideRepository
        .fetchGuideCategories()
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(
                guideCategoriesState: LoadingState.loading,
              ));
        })
        .onSuccess((data) {
          updateState((state) => state.copyWith(
                guideCategories: data,
                guideCategoriesState:
                    data.isEmpty ? LoadingState.empty : LoadingState.success,
              ));
        })
        .onError((error) {
          updateState((state) => state.copyWith(
                guideCategoriesState: LoadingState.error,
              ));
        })
        .onFinished(() {})
        .executeFuture();
  }
}
