import 'package:flutter/material.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';

/// Mock data used across the redesigned main tabs.
/// Values mirror the "Al-Muroshiru" Stitch concept screens because there
/// are no backing APIs yet.
class IslamicMockData {
  IslamicMockData._();

  static const String appTitle = 'Al-Muroshiru';

  static String get hijriDate => Strings.homeHijriDate;
  static String get gregorianDate => Strings.homeGregorianDate;

  static List<PrayerTimeItem> get prayerTimes => [
        PrayerTimeItem(name: Strings.prayerFajr, time: '04:12'),
        PrayerTimeItem(name: Strings.prayerDhuhr, time: '12:34'),
        PrayerTimeItem(name: Strings.prayerAsr, time: '16:21', isNext: true),
        PrayerTimeItem(name: Strings.prayerMaghrib, time: '19:42'),
        PrayerTimeItem(name: Strings.prayerIsha, time: '21:05'),
      ];

  static String get nextPrayerLabel => Strings.homeNextPrayerLabel;
  static String get nextPrayerCountdown => Strings.homeNextPrayerCountdown;

  static List<HomeQuickAction> get homeQuickActions => [
        HomeQuickAction(
          id: HomeQuickActionId.quran,
          title: Strings.quickActionQuranTitle,
          subtitle: Strings.quickActionQuranSubtitle,
          icon: Icons.menu_book_rounded,
        ),
        HomeQuickAction(
          id: HomeQuickActionId.howToPray,
          title: Strings.quickActionHowToPrayTitle,
          subtitle: Strings.quickActionHowToPraySubtitle,
          icon: Icons.school_rounded,
        ),
        HomeQuickAction(
          id: HomeQuickActionId.dua,
          title: Strings.quickActionDuaTitle,
          subtitle: Strings.quickActionDuaSubtitle,
          icon: Icons.auto_awesome_rounded,
        ),
        HomeQuickAction(
          id: HomeQuickActionId.findHalal,
          title: Strings.quickActionFindHalalTitle,
          subtitle: Strings.quickActionFindHalalSubtitle,
          icon: Icons.map_rounded,
        ),
      ];

  static SurahMock get currentSurah => SurahMock(
        name: Strings.surahFatihaName,
        arabicName: 'الفاتحة',
        subtitle: Strings.surahFatihaSubtitle,
        revelation: Strings.surahFatihaRevelation,
        description: Strings.surahFatihaDescription,
        verses: [
          VerseMock(
            number: 1,
            arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            transliteration: Strings.surahFatihaVerse01Transliteration,
            translation: Strings.surahFatihaVerse01Translation,
          ),
          VerseMock(
            number: 2,
            arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            transliteration: Strings.surahFatihaVerse02Transliteration,
            translation: Strings.surahFatihaVerse02Translation,
          ),
          VerseMock(
            number: 3,
            arabic: 'الرَّحْمَٰنِ الرَّحِيمِ',
            transliteration: Strings.surahFatihaVerse03Transliteration,
            translation: Strings.surahFatihaVerse03Translation,
          ),
          VerseMock(
            number: 4,
            arabic: 'مَالِكِ يَوْمِ الدِّينِ',
            transliteration: Strings.surahFatihaVerse04Transliteration,
            translation: Strings.surahFatihaVerse04Translation,
          ),
          VerseMock(
            number: 5,
            arabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
            transliteration: Strings.surahFatihaVerse05Transliteration,
            translation: Strings.surahFatihaVerse05Translation,
          ),
          VerseMock(
            number: 6,
            arabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
            transliteration: Strings.surahFatihaVerse06Transliteration,
            translation: Strings.surahFatihaVerse06Translation,
          ),
          VerseMock(
            number: 7,
            arabic:
                'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
            transliteration: Strings.surahFatihaVerse07Transliteration,
            translation: Strings.surahFatihaVerse07Translation,
          ),
        ],
      );

  static LearnCourseMock get learnCourse => LearnCourseMock(
        title: Strings.learnCourseTitle,
        description: Strings.learnCourseDescription,
        totalDays: 30,
        completedDays: 7,
        days: [
          LearnDayMock(
            day: 1,
            title: Strings.learnDay01Title,
            description: Strings.learnDay01Description,
            isCompleted: true,
          ),
          LearnDayMock(
            day: 2,
            title: Strings.learnDay02Title,
            description: Strings.learnDay02Description,
            isCompleted: true,
          ),
          LearnDayMock(
            day: 3,
            title: Strings.learnDay03Title,
            description: Strings.learnDay03Description,
            isCompleted: true,
          ),
          LearnDayMock(
            day: 4,
            title: Strings.learnDay04Title,
            description: Strings.learnDay04Description,
            isCompleted: true,
          ),
          LearnDayMock(
            day: 5,
            title: Strings.learnDay05Title,
            description: Strings.learnDay05Description,
            isCompleted: true,
          ),
          LearnDayMock(
            day: 6,
            title: Strings.learnDay06Title,
            description: Strings.learnDay06Description,
            isCompleted: true,
          ),
          LearnDayMock(
            day: 7,
            title: Strings.learnDay07Title,
            description: Strings.learnDay07Description,
            isCompleted: true,
          ),
          LearnDayMock(
            day: 8,
            title: Strings.learnDay08Title,
            description: Strings.learnDay08Description,
            isCompleted: false,
          ),
          LearnDayMock(
            day: 9,
            title: Strings.learnDay09Title,
            description: Strings.learnDay09Description,
            isCompleted: false,
          ),
          LearnDayMock(
            day: 10,
            title: Strings.learnDay10Title,
            description: Strings.learnDay10Description,
            isCompleted: false,
          ),
        ],
      );

  static List<KnowledgeCategoryMock> get knowledgeCategories => [
        KnowledgeCategoryMock(id: 'all', label: Strings.knowledgeCategoryAll),
        KnowledgeCategoryMock(
          id: 'workplace',
          label: Strings.knowledgeCategoryWorkplace,
        ),
        KnowledgeCategoryMock(
          id: 'family',
          label: Strings.knowledgeCategoryFamily,
        ),
        KnowledgeCategoryMock(id: 'food', label: Strings.knowledgeCategoryFood),
        KnowledgeCategoryMock(
          id: 'prayer',
          label: Strings.knowledgeCategoryPrayer,
        ),
      ];

  static List<KnowledgeArticleMock> get knowledgeArticles => [
        KnowledgeArticleMock(
          categoryId: 'workplace',
          categoryLabel: Strings.knowledgeArticleAlcoholCategory,
          title: Strings.knowledgeArticleAlcoholTitle,
          description: Strings.knowledgeArticleAlcoholDescription,
          icon: Icons.groups_rounded,
          iconBackground: const Color(0xFFF4E4B5),
        ),
        KnowledgeArticleMock(
          categoryId: 'food',
          categoryLabel: Strings.knowledgeArticleHalalFoodCategory,
          title: Strings.knowledgeArticleHalalFoodTitle,
          description: Strings.knowledgeArticleHalalFoodDescription,
          icon: Icons.restaurant_rounded,
          iconBackground: const Color(0xFFE5F1DF),
        ),
        KnowledgeArticleMock(
          categoryId: 'prayer',
          categoryLabel: Strings.knowledgeArticlePrayerRoomCategory,
          title: Strings.knowledgeArticlePrayerRoomTitle,
          description: Strings.knowledgeArticlePrayerRoomDescription,
          icon: Icons.mosque_rounded,
          iconBackground: const Color(0xFFE0E6DC),
        ),
        KnowledgeArticleMock(
          categoryId: 'family',
          categoryLabel: Strings.knowledgeArticleChildrenCategory,
          title: Strings.knowledgeArticleChildrenTitle,
          description: Strings.knowledgeArticleChildrenDescription,
          icon: Icons.family_restroom_rounded,
          iconBackground: const Color(0xFFF7E1D7),
        ),
      ];
}

class PrayerTimeItem {
  final String name;
  final String time;
  final bool isNext;

  const PrayerTimeItem({
    required this.name,
    required this.time,
    this.isNext = false,
  });
}

enum HomeQuickActionId { quran, howToPray, dua, findHalal }

class HomeQuickAction {
  final HomeQuickActionId id;
  final String title;
  final String subtitle;
  final IconData icon;

  const HomeQuickAction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class SurahMock {
  final String name;
  final String arabicName;
  final String subtitle;
  final String revelation;
  final String description;
  final List<VerseMock> verses;

  const SurahMock({
    required this.name,
    required this.arabicName,
    required this.subtitle,
    required this.revelation,
    required this.description,
    required this.verses,
  });
}

class VerseMock {
  final int number;
  final String arabic;
  final String transliteration;
  final String translation;

  const VerseMock({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });
}

class LearnCourseMock {
  final String title;
  final String description;
  final int totalDays;
  final int completedDays;
  final List<LearnDayMock> days;

  const LearnCourseMock({
    required this.title,
    required this.description,
    required this.totalDays,
    required this.completedDays,
    required this.days,
  });

  double get progress => totalDays == 0 ? 0 : completedDays / totalDays;
}

class LearnDayMock {
  final int day;
  final String title;
  final String description;
  final bool isCompleted;

  const LearnDayMock({
    required this.day,
    required this.title,
    required this.description,
    required this.isCompleted,
  });
}

class KnowledgeCategoryMock {
  final String id;
  final String label;

  const KnowledgeCategoryMock({required this.id, required this.label});
}

class KnowledgeArticleMock {
  final String categoryId;
  final String categoryLabel;
  final String title;
  final String description;
  final IconData icon;
  final Color iconBackground;

  const KnowledgeArticleMock({
    required this.categoryId,
    required this.categoryLabel,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBackground,
  });
}
