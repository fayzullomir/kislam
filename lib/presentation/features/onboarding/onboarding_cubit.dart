import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/data/datasource/preference/app_config_preferences.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'onboarding_cubit.freezed.dart';
part 'onboarding_state.dart';

@Injectable()
class OnboardingCubit extends BaseCubit<OnboardingState, OnboardingEvent> {
  final AppConfigPreferences _appConfigPreferences;

  OnboardingCubit(this._appConfigPreferences) : super(OnboardingState()) {
    _appConfigPreferences.setIsOnboardingShown(true);
  }

  void setPageIndex(int pageIndex) {
    updateState((state) => state.copyWith(currentPageIndex: pageIndex));
  }
}
