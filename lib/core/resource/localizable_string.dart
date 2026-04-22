import 'package:flutter/widgets.dart';

class LocalizableString {
  final String? uz;
  final String? ru;
  final String? en;
  final String? ar;
  final String? tg;

  const LocalizableString({
    this.uz,
    this.ru,
    this.en,
    this.ar,
    this.tg,
  });

  const LocalizableString.empty()
      : uz = null,
        ru = null,
        en = null,
        ar = null,
        tg = null;

  // ══════════════════════════════════════════════════════════════════════════
  // GETTERS
  // ══════════════════════════════════════════════════════════════════════════

  bool get isEmpty => uz == null && ru == null && en == null && ar == null && tg == null;

  bool get isNotEmpty => !isEmpty;

  /// Returns first non-null value or empty string
  String get value => uz ?? en ?? ru ?? ar ?? tg ?? '';

  /// Returns list of all non-null values
  List<String> get values => [uz, en, ru, ar, tg].whereType<String>().toList();

  // ══════════════════════════════════════════════════════════════════════════
  // LOCALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  String localized(BuildContext context, {String fallback = ''}) {
    final locale = Localizations.localeOf(context).languageCode;
    return localizedByLocaleCode(locale, fallback: fallback);
  }

  String localizedByLocaleCode(String localeCode, {String fallback = ''}) {
    final lang = localeCode.toLowerCase();

    if (lang.startsWith('uz')) return uz ?? en ?? ru ?? fallback;
    if (lang.startsWith('ru')) return ru ?? en ?? uz ?? fallback;
    if (lang.startsWith('en')) return en ?? uz ?? ru ?? fallback;
    if (lang.startsWith('ar')) return ar ?? en ?? uz ?? fallback;
    if (lang.startsWith('tg')) return tg ?? ru ?? en ?? uz ?? fallback;

    return uz ?? en ?? ru ?? fallback;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SEARCH & FILTERING
  // ══════════════════════════════════════════════════════════════════════════

  /// Checks if any localized string contains the [query].
  /// Case-insensitive by default.
  bool contains(String query, {bool caseSensitive = false}) {
    if (query.isEmpty) return true;
    final q = caseSensitive ? query : query.toLowerCase();
    return _match(uz, q, caseSensitive) ||
        _match(en, q, caseSensitive) ||
        _match(ru, q, caseSensitive) ||
        _match(ar, q, caseSensitive) ||
        _match(tg, q, caseSensitive);
  }

  /// Checks if the localized string for current locale contains the [query].
  bool containsLocalized(BuildContext context, String query, {bool caseSensitive = false}) {
    return containsByLocaleCode(Localizations.localeOf(context).languageCode, query, caseSensitive: caseSensitive);
  }

  /// Checks if the localized string for [localeCode] contains the [query].
  bool containsByLocaleCode(String localeCode, String query, {bool caseSensitive = false}) {
    if (query.isEmpty) return true;
    final value = localizedByLocaleCode(localeCode);
    final q = caseSensitive ? query : query.toLowerCase();
    final v = caseSensitive ? value : value.toLowerCase();
    return v.contains(q);
  }

  /// Checks if any localized string starts with the [prefix].
  bool startsWith(String prefix, {bool caseSensitive = false}) {
    if (prefix.isEmpty) return true;
    final p = caseSensitive ? prefix : prefix.toLowerCase();
    return _startsWith(uz, p, caseSensitive) ||
        _startsWith(en, p, caseSensitive) ||
        _startsWith(ru, p, caseSensitive) ||
        _startsWith(ar, p, caseSensitive) ||
        _startsWith(tg, p, caseSensitive);
  }

  /// Checks if any localized string equals the [other].
  bool equals(String other, {bool caseSensitive = false}) {
    final o = caseSensitive ? other : other.toLowerCase();
    return _equals(uz, o, caseSensitive) ||
        _equals(en, o, caseSensitive) ||
        _equals(ru, o, caseSensitive) ||
        _equals(ar, o, caseSensitive) ||
        _equals(tg, o, caseSensitive);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TRANSFORMATION
  // ══════════════════════════════════════════════════════════════════════════

  LocalizableString copyWith({
    String? uz,
    String? ru,
    String? en,
    String? ar,
    String? tg,
  }) {
    return LocalizableString(
      uz: uz ?? this.uz,
      ru: ru ?? this.ru,
      en: en ?? this.en,
      ar: ar ?? this.ar,
      tg: tg ?? this.tg,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // JSON SERIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  factory LocalizableString.fromJson(Map<String, dynamic> json) {
    return LocalizableString(
      uz: json['uz'] as String?,
      ru: json['ru'] as String?,
      en: json['en'] as String?,
      ar: json['ar'] as String?,
      tg: json['tg'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (uz != null) 'uz': uz,
      if (ru != null) 'ru': ru,
      if (en != null) 'en': en,
      if (ar != null) 'ar': ar,
      if (tg != null) 'tg': tg,
    };
  }

  // ══════════════════════════════════════════════════════════════════════════
  // OVERRIDES
  // ══════════════════════════════════════════════════════════════════════════

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocalizableString &&
        other.uz == uz &&
        other.ru == ru &&
        other.en == en &&
        other.ar == ar &&
        other.tg == tg;
  }

  @override
  int get hashCode => Object.hash(uz, ru, en, ar, tg);

  // ══════════════════════════════════════════════════════════════════════════
  // PRIVATE HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  bool _match(String? value, String query, bool caseSensitive) {
    if (value == null || value.isEmpty) return false;
    final v = caseSensitive ? value : value.toLowerCase();
    return v.contains(query);
  }

  bool _startsWith(String? value, String prefix, bool caseSensitive) {
    if (value == null || value.isEmpty) return false;
    final v = caseSensitive ? value : value.toLowerCase();
    return v.startsWith(prefix);
  }

  bool _equals(String? value, String other, bool caseSensitive) {
    if (value == null) return false;
    final v = caseSensitive ? value : value.toLowerCase();
    return v == other;
  }
}

// ════════════════════════════════════════════════════════════════════════════
// EXTENSIONS
// ════════════════════════════════════════════════════════════════════════════

extension LocalizableStringMapper on String? {
  LocalizableString toLocalized({String? ru, String? en, String? ar, String? tg}) {
    return LocalizableString(uz: this, ru: ru, en: en, ar: ar, tg: tg);
  }
}

extension LocalizableStringNullable on LocalizableString? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => !isNullOrEmpty;

  String localized(BuildContext context, {String fallback = ''}) {
    return (this ?? const LocalizableString.empty()).localized(context, fallback: fallback);
  }

  String localizedByCode(String localeCode, {String fallback = ''}) {
    return (this ?? const LocalizableString.empty()).localizedByLocaleCode(localeCode, fallback: fallback);
  }

  bool contains(String query, {bool caseSensitive = false}) {
    return (this ?? const LocalizableString.empty()).contains(query, caseSensitive: caseSensitive);
  }

  bool containsLocalized(BuildContext context, String query, {bool caseSensitive = false}) {
    return (this ?? const LocalizableString.empty()).containsLocalized(context, query, caseSensitive: caseSensitive);
  }

  bool containsByLocaleCode(String localeCode, String query, {bool caseSensitive = false}) {
    return (this ?? const LocalizableString.empty()).containsByLocaleCode(localeCode, query, caseSensitive: caseSensitive);
  }

  bool startsWith(String prefix, {bool caseSensitive = false}) {
    return (this ?? const LocalizableString.empty()).startsWith(prefix, caseSensitive: caseSensitive);
  }

  bool equals(String other, {bool caseSensitive = false}) {
    return (this ?? const LocalizableString.empty()).equals(other, caseSensitive: caseSensitive);
  }
}