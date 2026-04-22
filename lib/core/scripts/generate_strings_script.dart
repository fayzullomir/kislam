import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// ------------------------------------------------------------
/// 🔤 Localization Codegen Script
/// ------------------------------------------------------------
///
/// 📄 Documentation:
/// See `generate_strings_script.md` for full usage, input/output,
/// and update instructions.
///
/// ------------------------------------------------------------

Future<void> main() async {
  print('🔄 Localization generation started...\n');

  try {
    await _sortJsonKeys();
    await _generateLocaleKeys();
    await _convertKeysToCamelCase();
    // await _generateStringsClass();
    await _generateStringsClassWithParams();
    print('\n🎉 Localization generation completed successfully.');
  } catch (e, stack) {
    stderr.writeln('\n❌ Error occurred: $e');
    stderr.writeln(stack);
    exit(1);
  }
}

Future<void> _sortJsonKeys() async {
  final dir = Directory(_resolveProjectPath('assets/localization'));

  if (!await dir.exists()) {
    stderr.writeln('❌ assets/localization directory not found');
    exitCode = 1;
    return;
  }

  await for (final entity in dir.list(recursive: false)) {
    if (entity is! File || !entity.path.endsWith('.json')) continue;

    final jsonString = await entity.readAsString();
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    final sortedKeys = jsonMap.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    final sortedMap = {for (final k in sortedKeys) k: jsonMap[k]};

    const encoder = JsonEncoder.withIndent('  ');
    await entity.writeAsString(encoder.convert(sortedMap) + '\n');
  }
  print('✅ Step 1: Json fields sorted by alphabetically');
}

Future<void> _generateLocaleKeys() async {
  final result = await Process.run(
    'flutter',
    [
      'pub',
      'run',
      'easy_localization:generate',
      '-S',
      'assets/localization',
      '-O',
      'lib/core/gen/localization',
      '-f',
      'keys',
      '-o',
      'strings_locale_keys.g.dart',
    ],
    runInShell: true,
  );

  if (result.exitCode != 0) {
    throw Exception('easy_localization:generate failed:\n${result.stderr}');
  }

  final lines = result.stdout.toString().split('\n');
  final generatedLine = lines.firstWhere(
        (line) => line.contains('File generated in'),
    orElse: () => '',
  );

  if (generatedLine.isNotEmpty) {
    final pathMatch = RegExp(r'File generated in (.+)').firstMatch(generatedLine);
    final path = pathMatch?.group(1)?.trim() ?? '';
    print('✅ Step 2: Locale keys (snake_case) generated at: $path');
  } else {
    print('✅ Step 2: Locale keys (snake_case) generated.');
  }
}

Future<void> _convertKeysToCamelCase() async {
  final path = _resolveProjectPath('lib/core/gen/localization/strings_locale_keys.g.dart');
  final file = File(path);

  if (!await file.exists()) {
    throw Exception('Locale keys file not found at: ${file.path}');
  }

  final originalLines = await file.readAsLines();
  final updatedLines = originalLines.map((line) {
    if (!line.contains('static const')) return line;

    final match = RegExp(r"'(.*?)'").firstMatch(line);
    if (match == null) return line;

    final snake = match.group(1) ?? '';
    final camel = _snakeToCamelCase(snake);
    return "  static const $camel = '$snake';";
  }).toList();

  await file.writeAsString(updatedLines.join('\n'));
  print('✅ Step 3: Keys converted to camelCase.');
}

Future<void> _generateStringsClassWithParams() async {
  final localizationDir = Directory(_resolveProjectPath('assets/localization'));

  final firstJsonFile = await localizationDir
      .list()
      .where((f) => f is File && f.path.endsWith('.json'))
      .cast<File>()
      .first;

  final jsonMap = json.decode(await firstJsonFile.readAsString()) as Map<String, dynamic>;

  final localeKeysPath = _resolveProjectPath('lib/core/gen/localization/strings_locale_keys.g.dart');
  final outputPath = _resolveProjectPath('lib/core/gen/localization/strings.dart');

  final localeKeysFile = File(localeKeysPath);
  if (!await localeKeysFile.exists()) {
    throw Exception('Locale keys file not found at: $localeKeysPath');
  }

  final lines = await localeKeysFile.readAsLines();

  final buffer = StringBuffer()
    ..writeln("import 'package:easy_localization/easy_localization.dart';")
    ..writeln("import 'strings_locale_keys.g.dart';\n")
    ..writeln('class Strings {\n');

  for (final line in lines) {
    if (!line.contains('static const')) continue;

    final match = RegExp(r"static const (\w+) = '(\S+)';").firstMatch(line);
    if (match == null) continue;

    final camelKey = match.group(1)!;
    final snakeKey = match.group(2)!;

    final value = jsonMap[snakeKey];
    if (value is! String) {
      buffer.writeln("  static String get $camelKey => LocaleKeys.$camelKey.tr();");
      continue;
    }

    final argMatches = RegExp(r'\{(\w+)\}').allMatches(value);
    final args = argMatches.map((m) => m.group(1)!).toSet().toList();

    if (args.isEmpty) {
      buffer.writeln("  static String get $camelKey => LocaleKeys.$camelKey.tr();");
    } else {
      final argsSignature = args.map((a) => 'String $a').join(', ');
      final namedArgsMap = args.map((a) => "'$a': $a").join(', ');
      buffer.writeln(
          "  static String $camelKey($argsSignature) => LocaleKeys.$camelKey.tr(namedArgs: { $namedArgsMap });");
    }
  }

  buffer.writeln('}');
  await File(outputPath).writeAsString(buffer.toString());

  print('✅ Step 4: StringsWithArgs class with parameters created.');
}



String _snakeToCamelCase(String input) {
  final parts = input.split('_');
  if (parts.isEmpty) return input;
  return parts.first + parts.skip(1).map((w) => w[0].toUpperCase() + w.substring(1)).join();
}

/// Resolves path relative to project root
String _resolveProjectPath(String relativePath) {
  final scriptPath = File(Platform.script.toFilePath()).absolute.path;
  final projectRoot = p.normalize(p.join(scriptPath, '../../../..'));
  return p.join(projectRoot, relativePath);
}
