import 'dart:ui';

enum Language {
  uzbekLatin,
  englishUs,
  russianRu,
  koreanKr,
  arabicAr;

  String get apiCode {
    return switch (this) {
      // Language.uzbekLatin => "la",
      Language.uzbekLatin => "uz",
      Language.englishUs => "en",
      Language.russianRu => "ru",
      Language.koreanKr => "ko",
      Language.arabicAr => "ar",
    };
  }

  Locale get locale {
    return switch (this) {
      Language.uzbekLatin => Locale('uz', 'UZ'),
      Language.englishUs => Locale('en', 'US'),
      Language.russianRu => Locale('ru', 'RU'),
      Language.koreanKr => Locale('ko', 'KR'),
      Language.arabicAr => Locale('ar', 'AR'),
    };
  }

  static Language valueOrDefault(String? languageName) {
    return Language.values.firstWhere(
      (e) => e.name.toUpperCase() == languageName?.toUpperCase(),
      orElse: () => defaultLanguage,
    );
  }

  static Language get defaultLanguage => Language.uzbekLatin;
}
