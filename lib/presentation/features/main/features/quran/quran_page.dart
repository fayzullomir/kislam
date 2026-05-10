import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_design_tokens.dart';
import 'package:koreaislam/presentation/features/main/features/_shared/islamic_mock_data.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';

import 'quran_cubit.dart';

@RoutePage()
class QuranPage extends BasePage<QuranCubit, QuranState, QuranEvent> {
  const QuranPage({super.key});

  @override
  void onWidgetCreated(BuildContext context) {}

  @override
  Widget onWidgetBuild(BuildContext context, QuranState state) {
    final surah = IslamicMockData.currentSurah;
    return Scaffold(
      backgroundColor: IslamicDesignTokens.neutral,
      appBar: _SurahAppBar(surah: surah),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
            children: [
              _SurahHeaderCard(surah: surah),
              const SizedBox(height: 20),
              ...surah.verses.map((verse) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _VerseCard(verse: verse),
                  )),
            ],
          ),
          const Positioned(
            right: 20,
            bottom: 20,
            child: _QuranActionButtons(),
          ),
        ],
      ),
    );
  }
}

class _SurahAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SurahMock surah;

  const _SurahAppBar({required this.surah});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: IslamicDesignTokens.neutral,
      elevation: 0,
      toolbarHeight: 64,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surah.name,
                  style: const TextStyle(
                    fontFamily: IslamicDesignTokens.fontDisplay,
                    color: IslamicDesignTokens.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  surah.subtitle.toUpperCase(),
                  style: IslamicDesignTokens.tEyebrow,
                ),
              ],
            ),
          ),
          _RoundIcon(icon: Icons.text_fields_rounded, onTap: () {}),
          _RoundIcon(icon: Icons.bookmark_border_rounded, onTap: () {}),
          _RoundIcon(icon: Icons.notifications_none_rounded, onTap: () {}),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: IslamicDesignTokens.primary,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _SurahHeaderCard extends StatelessWidget {
  final SurahMock surah;

  const _SurahHeaderCard({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
      decoration: BoxDecoration(
        color: IslamicDesignTokens.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Faded book illustration in the bottom-right.
          Positioned(
            right: -20,
            bottom: -30,
            child: Opacity(
              opacity: 0.14,
              child: Icon(
                Icons.menu_book_rounded,
                size: 200,
                color: Colors.white,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: IslamicDesignTokens.secondaryWash,
                      borderRadius:
                          BorderRadius.circular(IslamicDesignTokens.radiusPill),
                    ),
                    child: Text(
                      surah.revelation,
                      style: const TextStyle(
                        fontFamily: IslamicDesignTokens.fontBody,
                        color: IslamicDesignTokens.primaryInk,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    surah.arabicName,
                    style: const TextStyle(
                      fontFamily: IslamicDesignTokens.fontArabic,
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                surah.name,
                style: const TextStyle(
                  fontFamily: IslamicDesignTokens.fontDisplay,
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                surah.description,
                style: TextStyle(
                  fontFamily: IslamicDesignTokens.fontBody,
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerseCard extends StatelessWidget {
  final VerseMock verse;

  const _VerseCard({required this.verse});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: IslamicDesignTokens.neutralSand,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _VerseNumber(number: verse.number),
              const SizedBox(width: 8),
              const _VersePlayButton(),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  verse.arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: IslamicDesignTokens.fontArabic,
                    color: IslamicDesignTokens.ink,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    height: 1.9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: IslamicDesignTokens.secondary,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  verse.transliteration,
                  style: const TextStyle(
                    fontFamily: IslamicDesignTokens.fontBody,
                    color: IslamicDesignTokens.inkMuted,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  verse.translation,
                  style: const TextStyle(
                    fontFamily: IslamicDesignTokens.fontBody,
                    color: IslamicDesignTokens.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerseNumber extends StatelessWidget {
  final int number;

  const _VerseNumber({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: IslamicDesignTokens.secondaryWash,
        shape: BoxShape.circle,
        border: Border.all(
          color: IslamicDesignTokens.secondary.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          fontFamily: IslamicDesignTokens.fontDisplay,
          color: IslamicDesignTokens.secondaryInk,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _VersePlayButton extends StatelessWidget {
  const _VersePlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: IslamicDesignTokens.secondary,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

// FAB stack: white search circle on top, big green play circle on bottom.
class _QuranActionButtons extends StatelessWidget {
  const _QuranActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: IslamicDesignTokens.surface,
          shape: const CircleBorder(),
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.12),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
            child: const SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                Icons.search_rounded,
                color: IslamicDesignTokens.primary,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Material(
          color: IslamicDesignTokens.primary,
          shape: const CircleBorder(),
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.18),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
            child: const SizedBox(
              width: 60,
              height: 60,
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
