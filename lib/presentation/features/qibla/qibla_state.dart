part of 'qibla_cubit.dart';

@freezed
class QiblaState with _$QiblaState {
  const QiblaState._();

  const factory QiblaState({
    /// Heading offset from Qibla in degrees (0 means facing Mecca).
    @Default(0) int degreesFromQibla,
    @Default('Seoul') String city,
    @Default(7140) int kmToMecca,
  }) = _QiblaState;

  bool get isFacingMecca => degreesFromQibla.abs() <= 2;
}

@freezed
class QiblaEvent with _$QiblaEvent {
  const factory QiblaEvent() = _QiblaEvent;
}
