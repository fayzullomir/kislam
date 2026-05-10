import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'pray_cubit.freezed.dart';
part 'pray_state.dart';

@injectable
class PrayCubit extends BaseCubit<PrayState, PrayEvent> {
  PrayCubit() : super(PrayState());

  /// Advance to the next step of the prayer guide.
  void next() {
    if (states.currentStep >= states.totalSteps - 1) return;
    updateState((s) => s.copyWith(currentStep: s.currentStep + 1));
  }

  /// Move to the previous step of the prayer guide.
  void back() {
    if (states.currentStep == 0) return;
    updateState((s) => s.copyWith(currentStep: s.currentStep - 1));
  }
}
