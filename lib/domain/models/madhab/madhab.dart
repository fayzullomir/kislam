/// Schools of Sunni Islamic jurisprudence (madhahib).
///
/// Used by the prayer-time calculator: Hanafi computes Asr when an
/// object's shadow equals twice its length, the other three use one
/// length. The user picks once during onboarding and can switch via
/// Profile → Madhab.
enum Madhab {
  hanafi,
  shafii,
  maliki,
  hanbali;

  static Madhab valueOrDefault(String? name) {
    return Madhab.values.firstWhere(
      (m) => m.name.toLowerCase() == name?.toLowerCase(),
      orElse: () => Madhab.hanafi,
    );
  }

  static Madhab get defaultMadhab => Madhab.hanafi;
}
