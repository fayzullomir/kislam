/// User-selected location used for prayer-time calculations and contextual
/// content. Set during the onboarding location step (either via GPS or
/// manually). Latitude / longitude are present only for GPS-detected
/// values — manual entries store just the human-readable names.
class UserLocation {
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? country;

  const UserLocation({
    this.latitude,
    this.longitude,
    this.city,
    this.country,
  });

  /// Whether this location has any usable data — either coordinates or
  /// at least one named field. Used by the picker to decide if "continue"
  /// can be enabled.
  bool get isSet =>
      (latitude != null && longitude != null) ||
      (city?.isNotEmpty ?? false) ||
      (country?.isNotEmpty ?? false);

  /// Display label, e.g. "Seoul, South Korea" — falls back gracefully
  /// when only one part is known.
  String get displayLabel {
    final parts = <String>[
      if (city?.isNotEmpty ?? false) city!,
      if (country?.isNotEmpty ?? false) country!,
    ];
    return parts.join(', ');
  }
}
