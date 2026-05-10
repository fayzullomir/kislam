import 'package:adhan_dart/adhan_dart.dart' as adhan;

/// The calculation methods the user can pick from in the prayer-time
/// settings sheet. Each value maps 1:1 to an [adhan.CalculationMethod] —
/// the picker shows them in the same order the underlying library
/// documents them.
///
/// [CalculationMethod.muslimWorldLeague] is the app default.
enum CalculationMethod {
  muslimWorldLeague,
  egyptian,
  karachi,
  ummAlQura,
  dubai,
  qatar,
  kuwait,
  moonsightingCommittee,
  northAmerica,
  turkiye,
  tehran,
  singapore,
  morocco;

  /// Resolve the [adhan.CalculationParameters] for this method. The library
  /// uses static factory methods (`muslimWorldLeague()` etc.) rather than
  /// a single constructor, so we switch on the enum value here.
  adhan.CalculationParameters get adhanParameters {
    switch (this) {
      case CalculationMethod.muslimWorldLeague:
        return adhan.CalculationMethodParameters.muslimWorldLeague();
      case CalculationMethod.egyptian:
        return adhan.CalculationMethodParameters.egyptian();
      case CalculationMethod.karachi:
        return adhan.CalculationMethodParameters.karachi();
      case CalculationMethod.ummAlQura:
        return adhan.CalculationMethodParameters.ummAlQura();
      case CalculationMethod.dubai:
        return adhan.CalculationMethodParameters.dubai();
      case CalculationMethod.qatar:
        return adhan.CalculationMethodParameters.qatar();
      case CalculationMethod.kuwait:
        return adhan.CalculationMethodParameters.kuwait();
      case CalculationMethod.moonsightingCommittee:
        return adhan.CalculationMethodParameters.moonsightingCommittee();
      case CalculationMethod.northAmerica:
        return adhan.CalculationMethodParameters.northAmerica();
      case CalculationMethod.turkiye:
        return adhan.CalculationMethodParameters.turkiye();
      case CalculationMethod.tehran:
        return adhan.CalculationMethodParameters.tehran();
      case CalculationMethod.singapore:
        return adhan.CalculationMethodParameters.singapore();
      case CalculationMethod.morocco:
        return adhan.CalculationMethodParameters.morocco();
    }
  }

  static CalculationMethod valueOrDefault(String? name) {
    return CalculationMethod.values.firstWhere(
      (m) => m.name.toLowerCase() == name?.toLowerCase(),
      orElse: () => defaultMethod,
    );
  }

  static CalculationMethod get defaultMethod =>
      CalculationMethod.muslimWorldLeague;
}
