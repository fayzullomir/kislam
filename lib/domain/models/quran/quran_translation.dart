import 'package:koreaislam/domain/models/language/language.dart';

/// Quran translations the user can read in the Quran feature. Each entry
/// pairs the translator's proper name with the language they translated
/// into — the picker groups by language and shows the translator label.
enum QuranTranslation {
  // English
  saheehInternational,
  yusufAli,
  pickthall,

  // Russian
  kuliev,
  porokhova,

  // Uzbek
  alauddinMansur,
  muhammadSodiq,

  // Korean
  choeYongGil;

  /// Translator's proper name — not localized (a translator's name stays
  /// the same regardless of UI language).
  String get translatorName {
    return switch (this) {
      QuranTranslation.saheehInternational => 'Saheeh International',
      QuranTranslation.yusufAli => 'Yusuf Ali',
      QuranTranslation.pickthall => 'Marmaduke Pickthall',
      QuranTranslation.kuliev => 'Эльмир Кулиев',
      QuranTranslation.porokhova => 'Валерия Порохова',
      QuranTranslation.alauddinMansur => 'Alouddin Mansur',
      QuranTranslation.muhammadSodiq => 'Muhammad Sodiq Muhammad Yusuf',
      QuranTranslation.choeYongGil => '최용길',
    };
  }

  /// The language this translation is written in. The sheet uses it to
  /// render a localized subtitle ("English", "Русский", …).
  Language get language {
    return switch (this) {
      QuranTranslation.saheehInternational ||
      QuranTranslation.yusufAli ||
      QuranTranslation.pickthall =>
        Language.englishUs,
      QuranTranslation.kuliev || QuranTranslation.porokhova =>
        Language.russianRu,
      QuranTranslation.alauddinMansur || QuranTranslation.muhammadSodiq =>
        Language.uzbekLatin,
      QuranTranslation.choeYongGil => Language.koreanKr,
    };
  }

  static QuranTranslation valueOrDefault(String? name) {
    return QuranTranslation.values.firstWhere(
      (e) => e.name.toLowerCase() == name?.toLowerCase(),
      orElse: () => defaultTranslation,
    );
  }

  static QuranTranslation get defaultTranslation =>
      QuranTranslation.saheehInternational;
}
