import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/data/datasource/preference/app_config_preferences.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'intro_cubit.freezed.dart';
part 'intro_state.dart';

@Injectable()
class IntroCubit extends BaseCubit<IntroState, IntroEvent> {
  final AppConfigPreferences _appConfigPreferences;

  IntroCubit(this._appConfigPreferences) : super(IntroState()) {
    _appConfigPreferences.setIsIntroShown(true);
  }

  void setPageIndex(int pageIndex) {
    updateState((state) => state.copyWith(currentPageIndex: pageIndex));
  }
}
