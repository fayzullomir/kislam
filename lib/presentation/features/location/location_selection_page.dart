import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/preference/location_preferences.dart';
import 'package:koreaislam/domain/models/location/user_location.dart';
import 'package:koreaislam/presentation/application/di/get_it_injection.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/router/app_router.dart';

/// Onboarding-flow location picker. Two paths:
///   1. GPS auto-detect — requests permission, fetches the device position,
///      reverse-geocodes city + country.
///   2. Manual entry — two text fields the user fills in themselves.
///
/// Whichever was last edited is what gets saved when "continue" is tapped.
@RoutePage()
class LocationSelectionPage extends StatefulWidget {
  const LocationSelectionPage({super.key});

  @override
  State<LocationSelectionPage> createState() => _LocationSelectionPageState();
}

enum _Mode { none, gps, manual }

/// Carries an already-localized, user-facing message for failures we raise
/// ourselves inside the GPS flow.
class _GpsError implements Exception {
  final String message;
  const _GpsError(this.message);
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  final LocationPreferences _prefs = getIt<LocationPreferences>();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  _Mode _mode = _Mode.none;
  bool _isDetecting = false;
  String? _gpsError;
  UserLocation _gpsLocation = const UserLocation();

  @override
  void initState() {
    super.initState();
    // Pre-fill from prefs if the user is revisiting the page. Manual
    // entries (no coordinates) are no longer accepted in this UI — we
    // only restore the GPS path so the existing selection remains valid
    // for prayer-time computation.
    final saved = _prefs.location;
    if (saved.isSet && saved.latitude != null && saved.longitude != null) {
      _mode = _Mode.gps;
      _gpsLocation = saved;
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show a transparent AppBar with a back arrow only when this page sits
    // on top of an existing stack (i.e. opened from profile). In the
    // first-run flow it's the deep-link root so we keep the canvas clean.
    final canPop = Navigator.canPop(context);
    return Scaffold(
      backgroundColor: context.noor.neutral,
      appBar: canPop
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: context.noor.ink,
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Strings.locationSelectionEyebrow,
                      textAlign: TextAlign.center,
                      style: context.noor.tEyebrow,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Strings.locationSelectionTitle,
                      textAlign: TextAlign.center,
                      style: context.noor.tDisplay,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      Strings.locationSelectionBody,
                      textAlign: TextAlign.center,
                      style: context.noor.tBody.copyWith(
                        color: context.noor.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _GpsCard(
                      isDetecting: _isDetecting,
                      isSelected: _mode == _Mode.gps,
                      detected: _gpsLocation,
                      errorMessage: _gpsError,
                      onTap: _detectViaGps,
                    ),
                    const SizedBox(height: 16),
                    _ManualCard(
                      cityController: _cityController,
                      countryController: _countryController,
                      isSelected: _mode == _Mode.manual,
                      onActivate: _onManualTap,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: _PrimaryButton(
                label: Strings.commonContinue,
                enabled: _canContinue,
                onTap: () => _onContinue(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _canContinue {
    if (_mode == _Mode.gps) return _gpsLocation.isSet;
    // Manual city entry is intentionally non-functional for now (the
    // proper city-search UI is still being built); we only show an
    // "under development" notice from `_onManualTap` and never let the
    // user continue through this path.
    return false;
  }

  /// Manual entry isn't ready yet — surface the standard "feature under
  /// development" snackbar and don't activate the card visually so the
  /// user knows the GPS option is the only working path.
  void _onManualTap() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(Strings.messageFeatureUnderDevelopment),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _detectViaGps() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isDetecting = true;
      _gpsError = null;
      _mode = _Mode.gps;
    });

    try {
      final servicesEnabled = await Geolocator.isLocationServiceEnabled();
      if (!servicesEnabled) {
        throw _GpsError(Strings.locationGpsServiceDisabled);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw _GpsError(Strings.locationGpsPermissionDenied);
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          timeLimit: Duration(seconds: 15),
        ),
      );
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final placemark = placemarks.isNotEmpty ? placemarks.first : null;

      if (!mounted) return;
      setState(() {
        _gpsLocation = UserLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          city: placemark?.locality?.isNotEmpty == true
              ? placemark!.locality
              : placemark?.administrativeArea,
          country: placemark?.country,
        );
        _isDetecting = false;
      });
    } catch (e, s) {
      AppLog.e('❌ GPS detection failed: $e', stackTrace: s);
      if (!mounted) return;
      setState(() {
        _isDetecting = false;
        _gpsError = _friendlyGpsError(e);
      });
    }
  }

  /// Maps any failure from the GPS flow onto a user-facing message. Our own
  /// [_GpsError]s already carry a localized string; everything else (platform
  /// channel errors, geocoding I/O failures, timeouts) is collapsed into a
  /// generic notice so raw technical text never reaches the UI.
  String _friendlyGpsError(Object error) {
    if (error is _GpsError) return error.message;
    if (error is TimeoutException) return Strings.locationGpsTimeout;
    if (error is LocationServiceDisabledException) {
      return Strings.locationGpsServiceDisabled;
    }
    if (error is PermissionDeniedException) {
      return Strings.locationGpsPermissionDenied;
    }
    return Strings.locationGpsDetectFailed;
  }

  Future<void> _onContinue(BuildContext context) async {
    // _canContinue gates this method to the GPS path only.
    await _prefs.setLocation(_gpsLocation);
    if (!context.mounted) return;
    // From profile (pushed on top of an existing stack) just pop back. From
    // the first-run flow (this page is the deep-link root) clear the stack
    // and land on Main.
    if (context.router.canPop()) {
      context.router.maybePop();
    } else {
      context.router.replaceAll([MainRoute()]);
    }
  }
}

// ---------------------------------------------------------------------------

class _GpsCard extends StatelessWidget {
  final bool isDetecting;
  final bool isSelected;
  final UserLocation detected;
  final String? errorMessage;
  final VoidCallback onTap;

  const _GpsCard({
    required this.isDetecting,
    required this.isSelected,
    required this.detected,
    required this.errorMessage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = isSelected && detected.isSet && !isDetecting;
    return Material(
      color: context.noor.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isDetecting ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? context.noor.primary : context.noor.line,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.my_location_rounded,
                color: context.noor.primary,
                size: 24,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.locationGpsDetectTitle,
                      style: TextStyle(
                        fontFamily: IslamicDesignTokens.fontDisplay,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: context.noor.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isDetecting
                          ? Strings.locationGpsDetecting
                          : isResolved
                              ? detected.displayLabel
                              : errorMessage ??
                                  Strings.locationGpsDetectSubtitle,
                      style: context.noor.tBodySm.copyWith(
                        color: errorMessage != null
                            ? context.noor.danger
                            : context.noor.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDetecting)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.noor.primary,
                  ),
                )
              else if (isResolved)
                Icon(Icons.check_rounded,
                    color: context.noor.primary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ManualCard extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController countryController;
  final bool isSelected;
  final VoidCallback onActivate;

  const _ManualCard({
    required this.cityController,
    required this.countryController,
    required this.isSelected,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    // Manual entry is intentionally disabled until the city-search UI is
    // built; tapping anywhere on the card surfaces an "under development"
    // notice via [onActivate]. We use [AbsorbPointer] over the inputs so
    // the keyboard never opens and a single GestureDetector owns the tap.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onActivate,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          color: context.noor.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? context.noor.primary : context.noor.line,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.edit_location_alt_rounded,
                  color: context.noor.secondary,
                  size: 24,
                ),
                const SizedBox(width: 14),
                Text(
                  Strings.locationManualTitle,
                  style: TextStyle(
                    fontFamily: IslamicDesignTokens.fontDisplay,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.noor.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AbsorbPointer(
              child: Column(
                children: [
                  _TextField(
                    controller: cityController,
                    hint: Strings.locationManualCityHint,
                    onActivate: onActivate,
                  ),
                  const SizedBox(height: 10),
                  _TextField(
                    controller: countryController,
                    hint: Strings.locationManualCountryHint,
                    onActivate: onActivate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback onActivate;

  const _TextField({
    required this.controller,
    required this.hint,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: onActivate,
      onChanged: (_) => onActivate(),
      style: TextStyle(
        fontFamily: IslamicDesignTokens.fontBody,
        fontSize: 15,
        color: context.noor.ink,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: context.noor.tBody.copyWith(color: context.noor.inkSoft),
        filled: true,
        fillColor: context.noor.neutral,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.noor.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.noor.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.noor.primary, width: 1.5),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? context.noor.primary
          : context.noor.primary.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
      child: InkWell(
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusBtn),
        onTap: enabled ? onTap : null,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: IslamicDesignTokens.fontDisplay,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
