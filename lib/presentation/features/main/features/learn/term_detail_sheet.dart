import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/book_cover.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/noor_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/terms_mock_data.dart';
import 'package:share_plus/share_plus.dart';

/// Bottom sheet shown when a term row is tapped in the Atamalar list.
/// Same layout as the design's TermDetailSheet: drag handle, close +
/// share row, scrollable body containing the term card (Arabic glyph,
/// name, short, divider, long), related terms chips, and prev/next
/// links.
Future<void> showTermDetailSheet(
  BuildContext context, {
  required String termId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) => _TermDetailSheet(termId: termId),
  );
}

class _TermDetailSheet extends StatelessWidget {
  final String termId;

  const _TermDetailSheet({required this.termId});

  @override
  Widget build(BuildContext context) {
    final term = TermsMockData.byId(termId);
    final n = context.noor;
    final localeCode = context.locale.languageCode;
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.85,
      decoration: BoxDecoration(
        color: n.neutral,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
            child: Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: n.lineStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Action bar
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkResponse(
                  onTap: () => Navigator.of(context).pop(),
                  radius: 22,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.close_rounded,
                      color: n.inkMuted,
                      size: 22,
                    ),
                  ),
                ),
                _ShareButton(
                  onTap: () => _shareTerm(context, term, localeCode),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.zero,
              children: [
                _TermCardBody(term: term, localeCode: localeCode),
                _RelatedTerms(current: term, localeCode: localeCode),
                _PrevNextStrip(current: term, localeCode: localeCode),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ShareButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Material(
      color: n.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: n.line, width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.share_outlined, color: n.ink, size: 15),
              const SizedBox(width: 6),
              Text(
                Strings.termShare,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontBody,
                  color: n.ink,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shared body — the design's TermCard. Pulled out so the share sheet's
/// preview card can render the same shape with different styling.
class _TermCardBody extends StatelessWidget {
  final TermMock term;
  final String localeCode;

  const _TermCardBody({required this.term, required this.localeCode});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final localized = term.localized(localeCode);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategoryPill(category: term.category),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ArabicGlyphTile(arabic: term.arabic),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localized.name,
                      style: TextStyle(
                        fontFamily: IslamicDesignTokens.fontDisplay,
                        color: n.ink,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      localized.short,
                      style: TextStyle(
                        fontFamily: IslamicDesignTokens.fontBody,
                        color: n.inkSoft,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _OrnamentedDivider(color: n.secondary),
          const SizedBox(height: 16),
          Text(Strings.termExplanationLabel, style: n.tEyebrow),
          const SizedBox(height: 8),
          Text(
            localized.long,
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontBody,
              color: n.ink,
              fontSize: 14.5,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final TermCategory category;

  const _CategoryPill({required this.category});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final label = _categoryLabel(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: n.primaryWash,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: n.secondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: IslamicDesignTokens.fontBody,
              color: n.inkMuted,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArabicGlyphTile extends StatelessWidget {
  final String arabic;

  const _ArabicGlyphTile({required this.arabic});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: n.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: n.primary.withOpacity(0.5),
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Text(
        arabic,
        style: const TextStyle(
          fontFamily: IslamicDesignTokens.fontArabic,
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Hairline gradient with a centered star ornament. Mirrors the
/// design's TermDetail "ornamented divider".
class _OrnamentedDivider extends StatelessWidget {
  final Color color;

  const _OrnamentedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  color.withOpacity(0.5),
                  color.withOpacity(0.5),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        StarOrnament(size: 11, color: color.withOpacity(0.95)),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.5),
                  color.withOpacity(0.5),
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

class _RelatedTerms extends StatelessWidget {
  final TermMock current;
  final String localeCode;

  const _RelatedTerms({required this.current, required this.localeCode});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final related = TermsMockData.all
        .where((t) => t.id != current.id && t.category == current.category)
        .take(4)
        .toList();
    if (related.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(Strings.termRelated, style: n.tEyebrow),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in related)
                _RelatedChip(
                  term: t,
                  localeCode: localeCode,
                  onTap: () {
                    // Replace the sheet content with the tapped related
                    // term — simplest is to pop+reopen so back-button
                    // history stays predictable.
                    Navigator.of(context).pop();
                    showTermDetailSheet(context, termId: t.id);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RelatedChip extends StatelessWidget {
  final TermMock term;
  final String localeCode;
  final VoidCallback onTap;

  const _RelatedChip({
    required this.term,
    required this.localeCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    return Material(
      color: n.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: n.line, width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                term.arabic,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontArabic,
                  color: n.secondaryInk,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                term.localized(localeCode).name,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontBody,
                  color: n.inkMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrevNextStrip extends StatelessWidget {
  final TermMock current;
  final String localeCode;

  const _PrevNextStrip({required this.current, required this.localeCode});

  @override
  Widget build(BuildContext context) {
    final n = context.noor;
    final all = TermsMockData.all;
    final idx = all.indexWhere((t) => t.id == current.id);
    final prev = idx > 0 ? all[idx - 1] : null;
    final next = idx < all.length - 1 ? all[idx + 1] : null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: prev == null
                  ? const SizedBox.shrink()
                  : _PrevNextCard(
                      direction: Strings.termPrevious,
                      name: prev.localized(localeCode).name,
                      alignEnd: false,
                      n: n,
                      onTap: () {
                        Navigator.of(context).pop();
                        showTermDetailSheet(context, termId: prev.id);
                      },
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: next == null
                  ? const SizedBox.shrink()
                  : _PrevNextCard(
                      direction: Strings.termNext,
                      name: next.localized(localeCode).name,
                      alignEnd: true,
                      n: n,
                      onTap: () {
                        Navigator.of(context).pop();
                        showTermDetailSheet(context, termId: next.id);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrevNextCard extends StatelessWidget {
  final String direction;
  final String name;
  final bool alignEnd;
  final NoorTokens n;
  final VoidCallback onTap;

  const _PrevNextCard({
    required this.direction,
    required this.name,
    required this.alignEnd,
    required this.n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: n.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: n.line, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment:
                alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                direction,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontBody,
                  color: n.inkSoft,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontDisplay,
                  color: n.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _shareTerm(BuildContext context, TermMock term, String localeCode) {
  final localized = term.localized(localeCode);
  final text = '${term.arabic} — ${localized.name}\n'
      '${localized.short}\n\n'
      '${localized.long}';
  final box = context.findRenderObject() as RenderBox?;
  SharePlus.instance.share(
    ShareParams(
      text: text,
      subject: localized.name,
      sharePositionOrigin:
          box == null ? null : box.localToGlobal(Offset.zero) & box.size,
    ),
  );
}

String _categoryLabel(TermCategory category) {
  switch (category) {
    case TermCategory.all:
      return Strings.termCategoryAll;
    case TermCategory.fiqh:
      return Strings.termCategoryFiqh;
    case TermCategory.ibodat:
      return Strings.termCategoryIbodat;
  }
}
