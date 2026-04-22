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
      backgroundColor: IslamicDesignTokens.background,
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
      backgroundColor: IslamicDesignTokens.background,
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
                    color: IslamicDesignTokens.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  surah.subtitle,
                  style: const TextStyle(
                    color: IslamicDesignTokens.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
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
            size: 24,
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: IslamicDesignTokens.primary,
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusLg),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.12,
              child: Icon(
                Icons.menu_book_rounded,
                size: 180,
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
                      color: IslamicDesignTokens.accentSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      surah.revelation,
                      style: const TextStyle(
                        color: IslamicDesignTokens.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    surah.arabicName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                surah.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                surah.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
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
        color: IslamicDesignTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(IslamicDesignTokens.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _VerseNumber(number: verse.number),
              const SizedBox(width: 8),
              _VersePlayButton(),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  verse.arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: IslamicDesignTokens.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: IslamicDesignTokens.accentSoft,
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
                    color: IslamicDesignTokens.textSecondary,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  verse.translation,
                  style: const TextStyle(
                    color: IslamicDesignTokens.textPrimary,
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
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: IslamicDesignTokens.accentSoft,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          color: IslamicDesignTokens.primaryDark,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _VersePlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: IslamicDesignTokens.accent,
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
          shadowColor: Colors.black.withOpacity(0.15),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
            child: const SizedBox(
              width: 60,
              height: 60,
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
