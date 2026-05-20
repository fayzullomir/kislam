import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/library_mock_data.dart';

/// Typographic book cover — locale-aware. Mirrors the design's BookCover
/// React component: palette tint, double-ruled border, optional star
/// ornament, centered title block, uppercase author at the bottom.
///
/// Implementation note: the double-ruled border is drawn via a single
/// CustomPaint rather than nested Positioned/IgnorePointer hacks. Flutter
/// 3.32's `RenderProxyBox` chokes on childless `DecoratedBox` instances
/// under tight Positioned constraints — using `CustomPaint` sidesteps
/// that and is cheaper anyway (no extra render objects).
class BookCover extends StatelessWidget {
  final BookMock book;
  final String locale;
  final double width;
  final double height;
  final bool showOrnament;

  const BookCover({
    super.key,
    required this.book,
    required this.locale,
    this.width = 150,
    this.height = 200,
    this.showOrnament = true,
  });

  bool get _titleIsKo => _isKoText(book.localized(locale).title);
  bool get _titleIsArabic => _isArabicText(book.localized(locale).title);
  bool get _subtitleIsArabic =>
      _isArabicText(book.localized(locale).subtitle);

  /// Title font size scales inversely with title length so long names
  /// don't overflow the cover. Korean / Arabic glyphs are wider, so
  /// we drop the per-char ratio for them.
  double get _titleFontSize {
    final title = book.localized(locale).title;
    final len = title.length.clamp(4, 999);
    final ratio = (_titleIsKo || _titleIsArabic) ? 2.0 : 2.6;
    final estimate = (width / len) * ratio;
    return estimate.clamp(13.0, 22.0);
  }

  String get _titleFont {
    if (_titleIsArabic) return IslamicDesignTokens.fontArabic;
    return IslamicDesignTokens.fontDisplay;
  }

  String get _subtitleFont {
    if (_subtitleIsArabic) return IslamicDesignTokens.fontArabic;
    return IslamicDesignTokens.fontBody;
  }

  @override
  Widget build(BuildContext context) {
    final palette = book.palette;
    final localized = book.localized(locale);
    final pad = (width * 0.09).roundToDouble();
    final ornamentSize = (width * 0.12).roundToDouble();
    final authorSize = (_titleFontSize * 0.42).roundToDouble();
    final subtitleSize = (_titleFontSize * 0.55).roundToDouble();
    final authorIsKo = _isKoText(localized.author);

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _CoverBackgroundPainter(palette: palette),
        child: Padding(
          padding: EdgeInsets.all(pad),
          child: Column(
            children: [
              if (showOrnament)
                Padding(
                  padding: EdgeInsets.only(top: (width * 0.06).roundToDouble()),
                  child: _Ornament8(
                    size: ornamentSize,
                    color: palette.sub.withOpacity(0.9),
                  ),
                ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: (width * 0.05).roundToDouble(),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (localized.subtitle.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              localized.subtitle,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: _subtitleFont,
                                fontSize: subtitleSize,
                                fontWeight: FontWeight.w500,
                                fontStyle: _subtitleIsArabic
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                                letterSpacing: 0.2,
                                color: palette.sub.withOpacity(0.9),
                              ),
                            ),
                          ),
                        Text(
                          localized.title,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: _titleFont,
                            fontSize: _titleFontSize,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                            letterSpacing: -0.2,
                            color: palette.fg,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: (width * 0.04).roundToDouble(),
                  left: 4,
                  right: 4,
                ),
                child: Text(
                  authorIsKo
                      ? localized.author
                      : localized.author.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: IslamicDesignTokens.fontBody,
                    fontSize: authorSize,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: palette.sub.withOpacity(0.85),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool _isKoText(String s) => RegExp(r'[가-힯]').hasMatch(s);
bool _isArabicText(String s) => RegExp(r'[؀-ۿ]').hasMatch(s);

/// Painter that draws:
///   1. The palette background fill (matches the palette's `bg` color)
///   2. A double-ruled border just inside the edge — outer rule at ~5%
///      of width, inner rule at ~7%.
class _CoverBackgroundPainter extends CustomPainter {
  final BookPalette palette;

  _CoverBackgroundPainter({required this.palette});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = const Radius.circular(4);
    final bgPaint = Paint()..color = palette.bg;
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      radius,
    );
    canvas.drawRRect(bgRect, bgPaint);

    final outerInset = (size.width * 0.045).roundToDouble();
    final innerInset = (size.width * 0.06).roundToDouble();
    final outerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        outerInset,
        outerInset,
        size.width - outerInset * 2,
        size.height - outerInset * 2,
      ),
      const Radius.circular(1),
    );
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        innerInset,
        innerInset,
        size.width - innerInset * 2,
        size.height - innerInset * 2,
      ),
      const Radius.circular(1),
    );
    final outerStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = palette.sub.withOpacity(0.55);
    final innerStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4
      ..color = palette.sub.withOpacity(0.35);
    canvas.drawRRect(outerRect, outerStroke);
    canvas.drawRRect(innerRect, innerStroke);
  }

  @override
  bool shouldRepaint(covariant _CoverBackgroundPainter old) =>
      old.palette != palette;
}

/// Tiny 8-pointed star ornament used inside book covers and section
/// dividers. Mirrors the design's `Ornament8` SVG.
class _Ornament8 extends StatelessWidget {
  final double size;
  final Color color;

  const _Ornament8({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _Ornament8Painter(color: color),
    );
  }
}

class _Ornament8Painter extends CustomPainter {
  final Color color;

  _Ornament8Painter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeJoin = StrokeJoin.round
      ..color = color;

    final w = size.width;
    final h = size.height;
    // Outer star (scaled from 0..24 viewBox).
    final outer = Path()
      ..moveTo(w * 12 / 24, h * 2 / 24)
      ..lineTo(w * 14 / 24, h * 10 / 24)
      ..lineTo(w * 22 / 24, h * 12 / 24)
      ..lineTo(w * 14 / 24, h * 14 / 24)
      ..lineTo(w * 12 / 24, h * 22 / 24)
      ..lineTo(w * 10 / 24, h * 14 / 24)
      ..lineTo(w * 2 / 24, h * 12 / 24)
      ..lineTo(w * 10 / 24, h * 10 / 24)
      ..close();
    final inner = Path()
      ..moveTo(w * 12 / 24, h * 5 / 24)
      ..lineTo(w * 13.5 / 24, h * 10.5 / 24)
      ..lineTo(w * 19 / 24, h * 12 / 24)
      ..lineTo(w * 13.5 / 24, h * 13.5 / 24)
      ..lineTo(w * 12 / 24, h * 19 / 24)
      ..lineTo(w * 10.5 / 24, h * 13.5 / 24)
      ..lineTo(w * 5 / 24, h * 12 / 24)
      ..lineTo(w * 10.5 / 24, h * 10.5 / 24)
      ..close();
    canvas.drawPath(outer, paint);
    canvas.drawPath(inner, paint);
  }

  @override
  bool shouldRepaint(covariant _Ornament8Painter old) => old.color != color;
}

/// Re-exported so callers (Kitoblar header, dividers, TermDetail) can
/// share the same star without re-implementing the painter.
class StarOrnament extends StatelessWidget {
  final double size;
  final Color color;

  const StarOrnament({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) => _Ornament8(size: size, color: color);
}
