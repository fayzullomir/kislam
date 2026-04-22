extension StringNameExtensions on String {
  static final RegExp _whitespacePattern = RegExp(r'\s+');
  static final RegExp _quotedTextPattern = RegExp(r'"[^"]*"');
  static final RegExp _wordPattern = RegExp(r'\b\w+\b');

  /// Capitalizes each word in person name
  /// Example: "JOHN DOE" -> "John Doe"
  String get capitalizedName {
    final trimmed = trim();
    if (trimmed.isEmpty) return this;

    return trimmed
        .toLowerCase()
        .split(_whitespacePattern)
        .where((word) => word.isNotEmpty)
        .map(_capitalizeWord)
        .join(' ');
  }

  /// Capitalizes company name while preserving quoted text
  /// Example: 'ООО "KOMPANIYA"' -> 'Ooo "KOMPANIYA"'
  String get capitalizedCompanyName {
    final trimmed = trim();
    if (trimmed.isEmpty) return this;

    // Store quoted parts
    final quotedParts = <String>[];
    var processed = trimmed.replaceAllMapped(_quotedTextPattern, (match) {
      quotedParts.add(match.group(0)!);
      return '\u0000${quotedParts.length - 1}\u0000';
    });

    // Capitalize words
    processed = processed.replaceAllMapped(_wordPattern, (match) {
      return _capitalizeWord(match.group(0)!);
    });

    // Restore quoted parts
    for (var i = 0; i < quotedParts.length; i++) {
      processed = processed.replaceFirst('\u0000$i\u0000', quotedParts[i]);
    }

    return processed;
  }

  /// Capitalizes first letter of a word
  String _capitalizeWord(String word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }

  /// Capitalizes only first letter of string
  /// Example: "hello world" -> "Hello world"
  String get capitalizedFirst {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Returns initials from name
  /// Example: "John Doe" -> "JD"
  String extractInitials({int maxLength = 2}) {
    final words = trim().split(_whitespacePattern);
    return words
        .where((w) => w.isNotEmpty)
        .take(maxLength)
        .map((w) => w[0].toUpperCase())
        .join();
  }
}