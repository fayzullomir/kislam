import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/book_cover.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/library_mock_data.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'quran_cubit.dart';

/// Kitoblar tab — the books library. Mirrors the design's
/// `KitoblarPage`: eyebrow + title header, full-width "continue reading"
/// hero (currently Qur'an), then the user's library list (1 card per
/// book, with cover thumb + language pills + progress).
///
/// File still lives at `features/main/features/quran/` so it remains
/// the second tab in `MainPage`'s `AutoTabsRouter`. The route name
/// (`QuranRoute`) is kept for the same reason; only the user-facing
/// chrome changes.
@RoutePage()
class QuranPage extends BasePage<QuranCubit, QuranState, QuranEvent> {
  const QuranPage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, QuranState state) {
    final localeCode = context.locale.languageCode;
    final books = LibraryMockData.all;
    final featured = books.firstWhere(
      (b) => b.id == LibraryMockData.quranBookId,
      orElse: () => books.first,
    );
    final rest = books.where((b) => b.id != featured.id).toList();

    return Scaffold(
      backgroundColor: context.noor.neutral,
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            const _KitoblarHeader(),
            const SizedBox(height: 18),
            _ContinueReadingCard(
              book: featured,
              localeCode: localeCode,
              onTap: () => _openReader(context, featured.id),
            ),
            const SizedBox(height: 26),
            const _LibrarySectionLabel(),
            const SizedBox(height: 18),
            ...List.generate(rest.length, (i) {
              return Padding(
                padding: EdgeInsets.only(bottom: i == rest.length - 1 ? 0 : 12),
                child: _BookListCard(
                  book: rest[i],
                  localeCode: localeCode,
                  onTap: () => _openReader(context, rest[i].id),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _openReader(BuildContext context, String bookId) {
    context.router.push(BookReaderRoute(bookId: bookId));
  }
}

// ---------------------------------------------------------------------------
// Header — eyebrow + title on the left, search & grid/list toggle on the
// right.
// ---------------------------------------------------------------------------

class _KitoblarHeader extends StatelessWidget {
  const _KitoblarHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Strings.libraryEyebrow, style: context.noor.tEyebrow),
              const SizedBox(height: 6),
              Text(
                Strings.libraryTitle,
                style: context.noor.tDisplay.copyWith(
                  fontSize: 34,
                  height: 1.0,
                  letterSpacing: -1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        _HeaderIconButton(
          icon: Icons.search_rounded,
          onTap: () {
            // TODO(library): open library search.
          },
        ),
        _HeaderIconButton(
          icon: Icons.grid_view_rounded,
          onTap: () {
            // TODO(library): toggle grid / list view.
          },
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: context.noor.inkMuted, size: 22),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// "Continue reading" hero card. Primary-green background with a faint
// geometric compass watermark; on the left is the book cover, on the
// right the title + last-read line + progress meter.
// ---------------------------------------------------------------------------

class _ContinueReadingCard extends StatelessWidget {
  final BookMock book;
  final String localeCode;
  final VoidCallback onTap;

  const _ContinueReadingCard({
    required this.book,
    required this.localeCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final localized = book.localized(localeCode);
    final percent = book.progressPercent;
    return Material(
      color: n.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Faded compass watermark, off the right edge.
              Positioned(
                top: -18,
                right: -22,
                child: Opacity(
                  opacity: 0.18,
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: CustomPaint(
                      painter: _CompassPainter(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    BookCover(
                      book: book,
                      locale: localeCode,
                      width: 86,
                      height: 116,
                      showOrnament: false,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.libraryContinuing,
                                style: TextStyle(
                                  fontFamily: IslamicDesignTokens.fontBody,
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                localized.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: IslamicDesignTokens.fontDisplay,
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              if (localized.lastRead != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  localized.lastRead!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: IslamicDesignTokens.fontBody,
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    Strings.libraryPagesFormat(
                                      '${book.read}',
                                      '${book.pages}',
                                    ),
                                    style: TextStyle(
                                      fontFamily: IslamicDesignTokens.fontBody,
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    Strings.libraryProgressPercent('$percent'),
                                    style: const TextStyle(
                                      fontFamily: IslamicDesignTokens.fontBody,
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              _ProgressBar(
                                fraction: book.progress,
                                trackColor: Colors.white.withOpacity(0.18),
                                fillColor: n.secondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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

/// Decorative compass/star painter shown faded in the hero card —
/// concentric circles + 4-point star.
class _CompassPainter extends CustomPainter {
  final Color color;

  _CompassPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 8;
    canvas.drawCircle(Offset(cx, cy), r, paint);
    canvas.drawCircle(Offset(cx, cy), r * 0.76, paint);
    canvas.drawCircle(Offset(cx, cy), r * 0.52, paint);
    // 4-point compass star
    final star = Path()
      ..moveTo(cx, cy - r)
      ..lineTo(cx + r * 0.05, cy - r * 0.1)
      ..lineTo(cx + r, cy)
      ..lineTo(cx + r * 0.05, cy + r * 0.1)
      ..lineTo(cx, cy + r)
      ..lineTo(cx - r * 0.05, cy + r * 0.1)
      ..lineTo(cx - r, cy)
      ..lineTo(cx - r * 0.05, cy - r * 0.1)
      ..close();
    canvas.drawPath(star, paint);
  }

  @override
  bool shouldRepaint(covariant _CompassPainter old) => old.color != color;
}

// ---------------------------------------------------------------------------
// Section label — gradient hairlines on either side, framed by two
// star ornaments and the "MY LIBRARY" eyebrow text.
// ---------------------------------------------------------------------------

class _LibrarySectionLabel extends StatelessWidget {
  const _LibrarySectionLabel();

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  n.secondary.withOpacity(0.5),
                  n.secondary.withOpacity(0.5),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        StarOrnament(size: 12, color: n.secondary.withOpacity(0.95)),
        const SizedBox(width: 10),
        Text(
          Strings.libraryMyLibrary,
          style: n.tEyebrow,
        ),
        const SizedBox(width: 10),
        StarOrnament(size: 12, color: n.secondary.withOpacity(0.95)),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  n.secondary.withOpacity(0.5),
                  n.secondary.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// List-mode book card: surface background, hairline border, cover thumb
// on the left, language pills + title + author + progress on the right.
// ---------------------------------------------------------------------------

class _BookListCard extends StatelessWidget {
  final BookMock book;
  final String localeCode;
  final VoidCallback onTap;

  const _BookListCard({
    required this.book,
    required this.localeCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final localized = book.localized(localeCode);
    return Material(
      color: n.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: n.line, width: 0.5),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BookCover(
                  book: book,
                  locale: localeCode,
                  width: 84,
                  height: 112,
                  showOrnament: false,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              for (final lang in book.langs.take(3)) ...[
                                _LangPill(label: lang),
                                const SizedBox(width: 4),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            localized.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: IslamicDesignTokens.fontDisplay,
                              color: n.ink,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              height: 1.22,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            localized.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: IslamicDesignTokens.fontBody,
                              color: n.inkSoft,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                      _BookListCardProgress(book: book, n: n),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookListCardProgress extends StatelessWidget {
  final BookMock book;
  final NoorTokens n;

  const _BookListCardProgress({required this.book, required this.n});

  @override
  Widget build(BuildContext context) {
    if (!book.isStarted) {
      // Books that have never been opened — show "X pages · Start →".
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Strings.libraryPagesTotal('${book.pages}'),
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontBody,
              color: n.inkSoft,
              fontSize: 11.5,
            ),
          ),
          Text(
            '${Strings.libraryStart} →',
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontBody,
              color: n.primary,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
    final done = book.isFinished;
    final progressColor = done ? n.secondary : n.primary;
    final accentInk = done ? n.secondaryInk : n.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              done
                  ? Strings.libraryFinishedShort
                  : Strings.libraryPagesFormat('${book.read}', '${book.pages}'),
              style: TextStyle(
                fontFamily: IslamicDesignTokens.fontBody,
                color: n.inkSoft,
                fontSize: 10.5,
              ),
            ),
            Text(
              done
                  ? '✓ 100%'
                  : Strings.libraryProgressPercent('${book.progressPercent}'),
              style: TextStyle(
                fontFamily: IslamicDesignTokens.fontBody,
                color: accentInk,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        _ProgressBar(
          fraction: book.progress,
          trackColor: n.ink.withOpacity(0.08),
          fillColor: progressColor,
        ),
      ],
    );
  }
}

class _LangPill extends StatelessWidget {
  final String label;

  const _LangPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: n.ink.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: IslamicDesignTokens.fontBody,
          color: n.inkMuted,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double fraction;
  final Color trackColor;
  final Color fillColor;

  const _ProgressBar({
    required this.fraction,
    required this.trackColor,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = fraction.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 3,
        child: Stack(
          children: [
            Container(color: trackColor),
            FractionallySizedBox(
              widthFactor: clamped,
              child: Container(color: fillColor),
            ),
          ],
        ),
      ),
    );
  }
}
