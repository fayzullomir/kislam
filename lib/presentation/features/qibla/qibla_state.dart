part of 'qibla_cubit.dart';

/// Lifecycle of the Qibla compass screen.
enum QiblaStatus {
  /// Default; initialization not started yet.
  initial,

  /// Acquiring location / waiting for the first compass tick.
  loading,

  /// Location resolved + compass stream emitting; UI shows the dial.
  ready,

  /// User refused the location permission for this session.
  permissionDenied,

  /// User refused permanently — only Settings can re-grant it.
  permissionPermanentlyDenied,

  /// Device location services are disabled at the OS level.
  serviceDisabled,

  /// Device has no magnetometer / compass sensor.
  noCompass,
}

@freezed
class QiblaState with _$QiblaState {
  const QiblaState._();

  const factory QiblaState({
    @Default(QiblaStatus.initial) QiblaStatus status,

    /// Device heading in degrees from true north (0..360, clockwise).
    @Default(0.0) double deviceHeading,

    /// Bearing from the user's current location to the Kaaba,
    /// in degrees from true north (0..360, clockwise).
    @Default(0.0) double qiblaBearing,

    /// Great-circle distance to the Kaaba, in kilometers.
    @Default(0) int kmToMecca,

    /// Reverse-geocoded city name (or empty while resolving).
    @Default('') String city,
  }) = _QiblaState;

  /// Signed offset the user must rotate by to face the Kaaba —
  /// positive = turn clockwise, negative = turn counter-clockwise.
  /// Range: [-180, 180].
  double get degreesFromQibla {
    final raw = qiblaBearing - deviceHeading;
    return ((raw + 540) % 360) - 180;
  }

  /// Integer projection used for the big number on screen (absolute value).
  int get degreesFromQiblaRounded => degreesFromQibla.abs().round();

  bool get isFacingMecca => degreesFromQibla.abs() <= 5;

  bool get isReady => status == QiblaStatus.ready;
}

@freezed
class QiblaEvent with _$QiblaEvent {
  const factory QiblaEvent() = _QiblaEvent;
}
