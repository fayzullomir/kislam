import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/terms_mock_data.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'learn_cubit.freezed.dart';
part 'learn_state.dart';

/// Learn tab hosts both the Q&A list and (per the new design) a side
/// tab of Islamic terms. The cubit tracks: which top-level tab is
/// active, the search query / Q&A category, and the term category
/// filter. Backed by mock data for now — wire to repositories in a
/// follow-up.
@injectable
class LearnCubit extends BaseCubit<LearnState, LearnEvent> {
  LearnCubit() : super(const LearnState());

  void selectTab(LearnTab tab) {
    if (states.tab == tab) return;
    updateState((s) => s.copyWith(tab: tab));
  }

  void selectCategory(String id) {
    if (states.selectedCategoryId == id) return;
    updateState((s) => s.copyWith(selectedCategoryId: id));
  }

  void updateSearchQuery(String query) {
    updateState((s) => s.copyWith(searchQuery: query));
  }

  void selectTermCategory(TermCategory category) {
    if (states.termCategory == category) return;
    updateState((s) => s.copyWith(termCategory: category));
  }
}
