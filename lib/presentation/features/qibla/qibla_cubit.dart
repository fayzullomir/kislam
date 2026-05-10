import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_compass/flutter_compass.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'qibla_cubit.freezed.dart';
part 'qibla_state.dart';

/// Compass / Qibla direction.
///
/// Pipeline:
///   1) Resolve permission + service state via [Geolocator].
///   2) Read a single position fix → compute bearing & distance to the Kaaba
///      with great-circle math, and reverse-geocode for the city label.
///   3) Subscribe to the magnetometer via [FlutterCompass.events]; each tick
///      updates [QiblaState.deviceHeading]. The page derives the needle
///      offset from `qiblaBearing - deviceHeading` (see [QiblaState]).
@injectable
class QiblaCubit extends BaseCubit<QiblaState, QiblaEvent> {
  QiblaCubit() : super(const QiblaState()) {
    init();
  }

  // Kaaba coordinates (Masjid al-Haram, Mecca).
  static const double _kaabaLat = 21.4225;
  static const double _kaabaLng = 39.8262;
  static const double _earthRadiusKm = 6371.0;

  StreamSubscription<CompassEvent>? _compassSub;

  Future<void> init() async {
    updateState((s) => s.copyWith(status: QiblaStatus.loading));

    // Magnetometer presence: wait briefly for the first compass event with
    // a non-null heading. If the stream times out or emits null, we surface
    // a clear "no compass" state instead of a stuck dial.
    CompassEvent? firstEvent;
    try {
      firstEvent =
          await FlutterCompass.events?.first.timeout(const Duration(seconds: 3));
    } on TimeoutException {
      firstEvent = null;
    }
    if (firstEvent?.heading == null) {
      updateState((s) => s.copyWith(status: QiblaStatus.noCompass));
      return;
    }

    final permissionOk = await _ensureLocationPermission();
    if (!permissionOk) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final bearing = _qiblaBearing(position.latitude, position.longitude);
      final distance = _distanceToMeccaKm(position.latitude, position.longitude);
      final city = await _resolveCity(position.latitude, position.longitude);

      updateState((s) => s.copyWith(
            status: QiblaStatus.ready,
            qiblaBearing: bearing,
            kmToMecca: distance.round(),
            city: city,
          ));

      _subscribeCompass();
    } catch (_) {
      // Treat fetch failures as service-disabled — the user has the same
      // recovery path (toggle GPS / try again).
      updateState((s) => s.copyWith(status: QiblaStatus.serviceDisabled));
    }
  }

  /// Re-runs the full init pipeline. Used by the "Try again" button.
  Future<void> retry() async {
    await _compassSub?.cancel();
    _compassSub = null;
    await init();
  }

  /// Opens the OS app-settings page so the user can flip the location
  /// permission back on after a permanent denial.
  Future<void> openAppSettings() => Geolocator.openAppSettings();

  /// Opens the OS location-services panel so the user can switch GPS on.
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      updateState((s) => s.copyWith(status: QiblaStatus.serviceDisabled));
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      updateState(
          (s) => s.copyWith(status: QiblaStatus.permissionPermanentlyDenied));
      return false;
    }
    if (permission == LocationPermission.denied) {
      updateState((s) => s.copyWith(status: QiblaStatus.permissionDenied));
      return false;
    }
    return true;
  }

  void _subscribeCompass() {
    _compassSub?.cancel();
    _compassSub = FlutterCompass.events?.listen((event) {
      final heading = event.heading;
      if (heading == null) return;
      // Normalize to [0, 360) — the platform sometimes returns negative
      // values when the device is held face-down.
      final normalized = (heading % 360 + 360) % 360;
      updateState((s) => s.copyWith(deviceHeading: normalized));
    });
  }

  /// Reverse-geocode the user's coordinates into a human-readable city.
  /// Falls back to an empty string on failure — UI hides the pill chunk.
  Future<String> _resolveCity(double lat, double lng) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return '';
      final p = placemarks.first;
      return p.locality?.isNotEmpty == true
          ? p.locality!
          : (p.subAdministrativeArea?.isNotEmpty == true
              ? p.subAdministrativeArea!
              : (p.administrativeArea ?? p.country ?? ''));
    } catch (_) {
      return '';
    }
  }

  /// Initial great-circle bearing from (lat, lng) to the Kaaba, in degrees
  /// from true north, normalized to [0, 360).
  static double _qiblaBearing(double lat, double lng) {
    final phi1 = _toRad(lat);
    final phi2 = _toRad(_kaabaLat);
    final deltaLambda = _toRad(_kaabaLng - lng);

    final y = math.sin(deltaLambda) * math.cos(phi2);
    final x = math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);

    final bearing = _toDeg(math.atan2(y, x));
    return (bearing + 360) % 360;
  }

  /// Haversine distance in kilometers from (lat, lng) to the Kaaba.
  static double _distanceToMeccaKm(double lat, double lng) {
    final phi1 = _toRad(lat);
    final phi2 = _toRad(_kaabaLat);
    final dPhi = _toRad(_kaabaLat - lat);
    final dLambda = _toRad(_kaabaLng - lng);

    final a = math.sin(dPhi / 2) * math.sin(dPhi / 2) +
        math.cos(phi1) *
            math.cos(phi2) *
            math.sin(dLambda / 2) *
            math.sin(dLambda / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return _earthRadiusKm * c;
  }

  static double _toRad(double deg) => deg * math.pi / 180.0;
  static double _toDeg(double rad) => rad * 180.0 / math.pi;

  @override
  Future<void> close() async {
    await _compassSub?.cancel();
    return super.close();
  }
}
