import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'learn_cubit.freezed.dart';
part 'learn_state.dart';

/// Learn tab now hosts the Q&A list (renamed from Knowledge in the new
/// design). Backed by mock data for now — wire to a real questions
/// repository in a follow-up.
@injectable
class LearnCubit extends BaseCubit<LearnState, LearnEvent> {
  LearnCubit() : super(const LearnState());

  void selectCategory(String id) {
    if (states.selectedCategoryId == id) return;
    updateState((s) => s.copyWith(selectedCategoryId: id));
  }

  void updateSearchQuery(String query) {
    updateState((s) => s.copyWith(searchQuery: query));
  }
}
