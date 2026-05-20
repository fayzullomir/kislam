import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/library_mock_data.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';

/// Reader screen for any book in the library. For the Qur'an book it
/// renders the standalone design's Qur'an page (Arabic ayah + translation
/// in the chosen reader font); for any other book it shows the design's
/// "IV bob · Islom ustunlari" generic placeholder chapter.
///
/// Reader chrome:
///   • Top bar — back, book title + page progress, bookmark, settings
///   • Progress strip — green track + "X / Y" indicator
///   • Reading area — Surah heading then ayah blocks (or paragraphs)
///   • Floating bottom toolbar (pill) — prev / contents / bookmarks /
///     search / next
///
/// All cosmetic settings (theme, font family, sizes, line height,
/// arabic-on toggle) live in local state and are mutated through the
/// settings bottom sheet.
@RoutePage()
class BookReaderPage extends StatefulWidget {
  final String bookId;

  const BookReaderPage({super.key, required this.bookId});

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  ReaderSettings _settings = const ReaderSettings();

  @override
  Widget build(BuildContext context) {
    final book = LibraryMockData.byId(widget.bookId);
    final localeCode = context.locale.languageCode;
    final theme = _settings.theme;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _ReaderTopBar(
                  book: book,
                  localeCode: localeCode,
                  theme: theme,
                  onBack: () => Navigator.of(context).maybePop(),
                  onBookmark: () {
                    // TODO(reader): persist bookmark via prefs.
                  },
                  onSettings: _openSettings,
                ),
                _ReaderProgress(book: book, theme: theme),
                Expanded(
                  child: _ReaderBody(
                    book: book,
                    localeCode: localeCode,
                    theme: theme,
                    settings: _settings,
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _ReaderBottomToolbar(theme: theme),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSettings() async {
    final updated = await showModalBottomSheet<ReaderSettings>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ReaderSettingsSheet(initial: _settings),
    );
    if (updated != null && mounted) {
      setState(() => _settings = updated);
    }
  }
}

// ---------------------------------------------------------------------------
// Reader chrome
// ---------------------------------------------------------------------------

class _ReaderTopBar extends StatelessWidget {
  final BookMock book;
  final String localeCode;
  final ReaderTheme theme;
  final VoidCallback onBack;
  final VoidCallback onBookmark;
  final VoidCallback onSettings;

  const _ReaderTopBar({
    required this.book,
    required this.localeCode,
    required this.theme,
    required this.onBack,
    required this.onBookmark,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final localized = book.localized(localeCode);
    final isQuran = book.id == LibraryMockData.quranBookId;
    String subtitle;
    if (isQuran) {
      final page = LibraryMockData.quranSamplePage;
      subtitle =
          '${page.surahName(localeCode)} · ${Strings.readerJuzPage('${page.juz}', '${page.page}')}';
    } else {
      subtitle =
          Strings.libraryPagesFormat('${book.read}', '${book.pages}');
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      child: Row(
        children: [
          _BarIconButton(
            icon: Icons.chevron_left_rounded,
            color: theme.text,
            onTap: onBack,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  localized.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: IslamicDesignTokens.fontDisplay,
                    color: theme.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: IslamicDesignTokens.fontBody,
                    color: theme.muted,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          _BarIconButton(
            icon: Icons.bookmark_outline_rounded,
            color: theme.text,
            onTap: onBookmark,
          ),
          _BarIconButton(
            icon: Icons.format_size_rounded,
            color: theme.text,
            onTap: onSettings,
          ),
        ],
      ),
    );
  }
}

class _BarIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BarIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

class _ReaderProgress extends StatelessWidget {
  final BookMock book;
  final ReaderTheme theme;

  const _ReaderProgress({required this.book, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isQuran = book.id == LibraryMockData.quranBookId;
    // For the Qur'an demo we hard-code the design's 187/604 (~31%); for
    // any other book we use the mock's actual read/pages ratio.
    final fraction = isQuran ? 187 / 604 : book.progress;
    final readLabel = isQuran ? '187' : '${book.read}';
    final totalLabel = isQuran ? '604' : '${book.pages}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 2,
                child: Stack(
                  children: [
                    Container(color: theme.text.withOpacity(0.12)),
                    FractionallySizedBox(
                      widthFactor: fraction.clamp(0.0, 1.0),
                      child: Container(color: theme.accent),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            Strings.readerPagesProgress(readLabel, totalLabel),
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontBody,
              color: theme.muted,
              fontSize: 10.5,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReaderBody extends StatelessWidget {
  final BookMock book;
  final String localeCode;
  final ReaderTheme theme;
  final ReaderSettings settings;

  const _ReaderBody({
    required this.book,
    required this.localeCode,
    required this.theme,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    if (book.id == LibraryMockData.quranBookId) {
      return _QuranReaderBody(
        localeCode: localeCode,
        theme: theme,
        settings: settings,
      );
    }
    return _GenericReaderBody(
      localeCode: localeCode,
      theme: theme,
      settings: settings,
    );
  }
}

class _QuranReaderBody extends StatelessWidget {
  final String localeCode;
  final ReaderTheme theme;
  final ReaderSettings settings;

  const _QuranReaderBody({
    required this.localeCode,
    required this.theme,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final page = LibraryMockData.quranSamplePage;
    final bodyFont = settings.font == ReaderFont.serif
        ? IslamicDesignTokens.fontDisplay
        : IslamicDesignTokens.fontBody;
    final surahName = page.surahName(localeCode);
    return ListView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 100),
      children: [
        // Surah heading
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
          child: Column(
            children: [
              Text(
                page.surahArabic,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontArabic,
                  color: theme.accent,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                surahName.toUpperCase(),
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontBody,
                  color: theme.muted,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 0.5,
          color: theme.text.withOpacity(0.15),
        ),
        const SizedBox(height: 16),
        for (final ayah in page.ayahs)
          Padding(
            padding: const EdgeInsets.only(bottom: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (settings.showArabic) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            ayah.arabic,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: IslamicDesignTokens.fontArabic,
                              color: theme.text,
                              fontSize: settings.arabicSize,
                              height: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _AyahNumberBadge(
                          number: ayah.number,
                          color: theme.accent,
                        ),
                      ],
                    ),
                  ),
                ],
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${ayah.number}  ',
                        style: TextStyle(
                          fontFamily: IslamicDesignTokens.fontBody,
                          color: theme.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ayah.translation(localeCode),
                        style: TextStyle(
                          fontFamily: bodyFont,
                          color: theme.text,
                          fontSize: settings.textSize,
                          height: settings.lineHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AyahNumberBadge extends StatelessWidget {
  final int number;
  final Color color;

  const _AyahNumberBadge({required this.number, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        '$number',
        style: TextStyle(
          fontFamily: IslamicDesignTokens.fontBody,
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GenericReaderBody extends StatelessWidget {
  final String localeCode;
  final ReaderTheme theme;
  final ReaderSettings settings;

  const _GenericReaderBody({
    required this.localeCode,
    required this.theme,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final chapter = localeCode == 'ko'
        ? LibraryMockData.sampleChapterKo
        : LibraryMockData.sampleChapterUz;
    final bodyFont = settings.font == ReaderFont.serif
        ? IslamicDesignTokens.fontDisplay
        : IslamicDesignTokens.fontBody;
    return ListView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 100),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            chapter.title,
            style: TextStyle(
              fontFamily: bodyFont,
              color: theme.text,
              fontSize: settings.textSize + 6,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        for (final paragraph in chapter.paragraphs)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              paragraph,
              style: TextStyle(
                fontFamily: bodyFont,
                color: theme.text,
                fontSize: settings.textSize,
                height: settings.lineHeight,
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Floating pill toolbar
// ---------------------------------------------------------------------------

class _ReaderBottomToolbar extends StatelessWidget {
  final ReaderTheme theme;

  const _ReaderBottomToolbar({required this.theme});

  @override
  Widget build(BuildContext context) {
    final bg = theme.isDark
        ? const Color(0xFF23231F)
        : Colors.white;
    final items = <_ToolbarAction>[
      _ToolbarAction(
        icon: Icons.chevron_left_rounded,
        label: Strings.readerToolbarPrev,
        dimmed: false,
      ),
      _ToolbarAction(
        icon: Icons.menu_rounded,
        label: Strings.readerToolbarPages,
        dimmed: true,
      ),
      _ToolbarAction(
        icon: Icons.bookmark_outline_rounded,
        label: Strings.readerToolbarBookmark,
        dimmed: false,
      ),
      _ToolbarAction(
        icon: Icons.search_rounded,
        label: Strings.readerToolbarSearch,
        dimmed: true,
      ),
      _ToolbarAction(
        icon: Icons.chevron_right_rounded,
        label: Strings.readerToolbarNext,
        dimmed: false,
      ),
    ];
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: theme.text.withOpacity(0.15),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final action in items)
              Tooltip(
                message: action.label,
                child: InkResponse(
                  radius: 22,
                  onTap: () {
                    // TODO(reader): wire toolbar actions.
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Icon(
                      action.icon,
                      color: theme.text.withOpacity(action.dimmed ? 0.65 : 1),
                      size: 18,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarAction {
  final IconData icon;
  final String label;
  final bool dimmed;

  const _ToolbarAction({
    required this.icon,
    required this.label,
    required this.dimmed,
  });
}

// ---------------------------------------------------------------------------
// Settings bottom sheet
// ---------------------------------------------------------------------------

class _ReaderSettingsSheet extends StatefulWidget {
  final ReaderSettings initial;

  const _ReaderSettingsSheet({required this.initial});

  @override
  State<_ReaderSettingsSheet> createState() => _ReaderSettingsSheetState();
}

class _ReaderSettingsSheetState extends State<_ReaderSettingsSheet> {
  late ReaderSettings _draft = widget.initial;

  void _patch(ReaderSettings next) {
    setState(() => _draft = next);
  }

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Container(
      decoration: BoxDecoration(
        color: n.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: n.lineStrong,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.readerSettingsTitle,
                    style: TextStyle(
                      fontFamily: IslamicDesignTokens.fontDisplay,
                      color: n.ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Material(
                    color: n.primary,
                    borderRadius: BorderRadius.circular(999),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => Navigator.of(context).pop(_draft),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        child: Text(
                          Strings.readerSettingsDone,
                          style: const TextStyle(
                            fontFamily: IslamicDesignTokens.fontBody,
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(Strings.readerSettingsTheme, style: n.tEyebrow),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final theme in ReaderTheme.allThemes)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _ThemeSwatchButton(
                          theme: theme,
                          selected: _draft.theme == theme,
                          onTap: () =>
                              _patch(_draft.copyWith(theme: theme)),
                          primary: n.primary,
                          line: n.line,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(Strings.readerSettingsFont, style: n.tEyebrow),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _FontChoiceButton(
                      label: Strings.readerSettingsSerif,
                      font: IslamicDesignTokens.fontDisplay,
                      selected: _draft.font == ReaderFont.serif,
                      onTap: () =>
                          _patch(_draft.copyWith(font: ReaderFont.serif)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FontChoiceButton(
                      label: Strings.readerSettingsSans,
                      font: IslamicDesignTokens.fontBody,
                      selected: _draft.font == ReaderFont.sans,
                      onTap: () =>
                          _patch(_draft.copyWith(font: ReaderFont.sans)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SliderRow(
                label: Strings.readerSettingsTextSize,
                value: _draft.textSize,
                min: 13,
                max: 22,
                onChanged: (v) => _patch(_draft.copyWith(textSize: v)),
              ),
              _SliderRow(
                label: Strings.readerSettingsArabicSize,
                value: _draft.arabicSize,
                min: 20,
                max: 34,
                onChanged: (v) => _patch(_draft.copyWith(arabicSize: v)),
              ),
              _SliderRow(
                label: Strings.readerSettingsLineHeight,
                value: _draft.lineHeight * 10,
                min: 14,
                max: 22,
                onChanged: (v) =>
                    _patch(_draft.copyWith(lineHeight: v / 10)),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.readerSettingsShowArabic,
                    style: TextStyle(
                      fontFamily: IslamicDesignTokens.fontBody,
                      color: n.ink,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _ArabicToggle(
                    value: _draft.showArabic,
                    onChanged: (v) => _patch(_draft.copyWith(showArabic: v)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeSwatchButton extends StatelessWidget {
  final ReaderTheme theme;
  final bool selected;
  final VoidCallback onTap;
  final Color primary;
  final Color line;

  const _ThemeSwatchButton({
    required this.theme,
    required this.selected,
    required this.onTap,
    required this.primary,
    required this.line,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? primary : line,
            width: selected ? 2 : 0.5,
          ),
        ),
        child: Text(
          'Aa',
          style: TextStyle(
            fontFamily: IslamicDesignTokens.fontDisplay,
            color: theme.text,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _FontChoiceButton extends StatelessWidget {
  final String label;
  final String font;
  final bool selected;
  final VoidCallback onTap;

  const _FontChoiceButton({
    required this.label,
    required this.font,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? n.primaryWash : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? n.primary : n.line,
            width: selected ? 1 : 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: font,
            color: n.ink,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(label, style: n.tEyebrow),
              Text(
                value.round().toString(),
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontBody,
                  color: n.inkMuted,
                  fontSize: 11.5,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: n.primary,
              inactiveTrackColor: n.line,
              thumbColor: n.primary,
              overlayColor: n.primary.withOpacity(0.1),
              trackHeight: 3,
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: (max - min).toInt(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArabicToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ArabicToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: IslamicDesignTokens.durFast,
        curve: IslamicDesignTokens.easeNoor,
        width: 42,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? n.primary : n.lineStrong,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Settings model & themes
// ---------------------------------------------------------------------------

class ReaderSettings {
  final ReaderTheme theme;
  final ReaderFont font;
  final double textSize;
  final double arabicSize;
  final double lineHeight;
  final bool showArabic;

  const ReaderSettings({
    this.theme = ReaderTheme.paper,
    this.font = ReaderFont.serif,
    this.textSize = 17,
    this.arabicSize = 26,
    this.lineHeight = 1.7,
    this.showArabic = true,
  });

  ReaderSettings copyWith({
    ReaderTheme? theme,
    ReaderFont? font,
    double? textSize,
    double? arabicSize,
    double? lineHeight,
    bool? showArabic,
  }) {
    return ReaderSettings(
      theme: theme ?? this.theme,
      font: font ?? this.font,
      textSize: textSize ?? this.textSize,
      arabicSize: arabicSize ?? this.arabicSize,
      lineHeight: lineHeight ?? this.lineHeight,
      showArabic: showArabic ?? this.showArabic,
    );
  }
}

enum ReaderFont { serif, sans }

/// Reader background/foreground palette presets — match the design's
/// READER_THEMES map (paper / cream / sepia / dark / black).
class ReaderTheme {
  final String id;
  final Color background;
  final Color text;
  final Color muted;
  final Color accent;
  final bool isDark;

  const ReaderTheme._({
    required this.id,
    required this.background,
    required this.text,
    required this.muted,
    required this.accent,
    required this.isDark,
  });

  static const paper = ReaderTheme._(
    id: 'paper',
    background: Color(0xFFF4EFE2),
    text: Color(0xFF1A1C1A),
    muted: Color(0xFF5A5E55),
    accent: Color(0xFF0F5132),
    isDark: false,
  );
  static const cream = ReaderTheme._(
    id: 'cream',
    background: Color(0xFFFBF8EE),
    text: Color(0xFF1A1C1A),
    muted: Color(0xFF5A5E55),
    accent: Color(0xFF0F5132),
    isDark: false,
  );
  static const sepia = ReaderTheme._(
    id: 'sepia',
    background: Color(0xFFE8DCC2),
    text: Color(0xFF2E2718),
    muted: Color(0xFF6B5C3E),
    accent: Color(0xFF7A5A1F),
    isDark: false,
  );
  static const dark = ReaderTheme._(
    id: 'dark',
    background: Color(0xFF1A1C1A),
    text: Color(0xFFEDEAE0),
    muted: Color(0xFF9A968A),
    accent: Color(0xFF4FB37C),
    isDark: true,
  );
  static const black = ReaderTheme._(
    id: 'black',
    background: Color(0xFF0A0A0A),
    text: Color(0xFFD8D5CA),
    muted: Color(0xFF7A786F),
    accent: Color(0xFF4FB37C),
    isDark: true,
  );

  static const allThemes = [paper, cream, sepia, dark, black];
}
