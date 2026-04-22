import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'main_cubit.freezed.dart';
part 'main_state.dart';

@Injectable()
class MainCubit extends BaseCubit<MainState, MainEvent> {
  MainCubit() : super(MainState()) {
    _subscribeStreams();
  }

  void _subscribeStreams() {}

  void setBottomNavHeight(double height) {
    updateState((state) => state.copyWith(bottomNavHeight: height));
  }
}
