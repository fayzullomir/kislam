import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/data/repositories/theme_mode/theme_mode_repository.dart';
import 'package:koreaislam/domain/channels/app_theme_mode_channel.dart';
import 'package:koreaislam/domain/models/theme/app_theme_mode.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'change_theme_mode_cubit.freezed.dart';
part 'change_theme_mode_state.dart';

@Injectable()
class ChangeThemeModeCubit
    extends BaseCubit<ChangeThemeModeState, ChangeThemeModeEvent> {
  final AppThemeModeChannel _appThemeModeChannel;
  final ThemeModeRepository _themeModeRepository;

  ChangeThemeModeCubit(
    this._appThemeModeChannel,
    this._themeModeRepository,
  ) : super(ChangeThemeModeState()) {
    _getThemeMode();
  }

  void _getThemeMode() async {
    final appThemeMode = _themeModeRepository.getAppThemeMode();
    updateState((state) => state.copyWith(appThemeMode: appThemeMode));
  }

  void setSelectedThemeMode(AppThemeMode appThemeMode) async {
    await _themeModeRepository.setAppThemeMode(appThemeMode);
    updateState((state) => state.copyWith(appThemeMode: appThemeMode));
    _appThemeModeChannel.add(appThemeMode);
  }
}
