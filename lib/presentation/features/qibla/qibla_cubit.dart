import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'qibla_cubit.freezed.dart';
part 'qibla_state.dart';

/// Compass / Qibla direction state. Mock heading + distance for now;
/// hook up to magnetometer + great-circle bearing in a follow-up.
@injectable
class QiblaCubit extends BaseCubit<QiblaState, QiblaEvent> {
  QiblaCubit() : super(const QiblaState());
}
