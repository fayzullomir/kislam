import 'package:flutter/material.dart';

/// Library / Kitoblar mock data — mirrors the standalone design's BOOKS
/// list and PALETTES map. Each entry carries locale-aware title / author
/// / subtitle / lastRead strings so the UI can render in UZ or KO without
/// hitting easy_localization for content (only chrome strings do).
class LibraryMockData {
  LibraryMockData._();

  static const String quranBookId = 'quran';

  static List<BookMock> get all => const [
        BookMock(
          id: 'quran',
          palette: BookPalette.quran,
          pages: 604,
          read: 187,
          langs: ['UZ', 'AR'],
          uz: BookLocalization(
            title: "Qurʼoni Karim",
            subtitle: 'القرآن',
            author: '114 sura',
            lastRead: 'Al-Baqara · 153-oyat',
          ),
          ko: BookLocalization(
            title: '꾸란',
            subtitle: 'القرآن',
            author: '114장',
            lastRead: '바까라 · 153절',
          ),
        ),
        BookMock(
          id: 'prayer-guide',
          palette: BookPalette.sky,
          pages: 128,
          read: 86,
          langs: ['UZ', 'KO'],
          uz: BookLocalization(
            title: "Namoz qoʻllanmasi",
            subtitle: '예배 입문',
            author: 'Korea Muslim Federation',
            lastRead: 'Kecha · 86-bet',
          ),
          ko: BookLocalization(
            title: '예배 입문',
            subtitle: 'Guide to Prayer',
            author: '한국이슬람교중앙회',
            lastRead: '어제 · 86쪽',
          ),
        ),
        BookMock(
          id: 'true-religion',
          palette: BookPalette.forest,
          pages: 96,
          read: 12,
          langs: ['UZ', 'EN'],
          uz: BookLocalization(
            title: 'Allohning haqiqiy dini',
            subtitle: 'The True Religion of God',
            author: 'Abu Ameenah Bilal Philips',
            lastRead: '3 kun avval · 12-bet',
          ),
          ko: BookLocalization(
            title: '하나님의 참된 종교',
            subtitle: 'The True Religion of God',
            author: '빌람 필립스',
            lastRead: '3일 전 · 12쪽',
          ),
        ),
        BookMock(
          id: 'iman-islam',
          palette: BookPalette.mist,
          pages: 240,
          read: 0,
          langs: ['UZ', 'KO', 'TR'],
          uz: BookLocalization(
            title: 'Iymon va Islom',
            subtitle: 'Îmân ve İslâm',
            author: 'Hüseyin Hilmi Işık',
            lastRead: null,
          ),
          ko: BookLocalization(
            title: '믿음과 이슬람',
            subtitle: 'Îmân ve İslâm',
            author: '후세인 힐미 으쓰크',
            lastRead: null,
          ),
        ),
        BookMock(
          id: 'true-happiness',
          palette: BookPalette.teal,
          pages: 72,
          read: 32,
          langs: ['UZ', 'EN', 'AR'],
          uz: BookLocalization(
            title: 'Haqiqiy baxtni izlash',
            subtitle: 'بحثاً عن السعادة',
            author: 'KMF kutubxonasi',
            lastRead: '1 hafta avval · 32-bet',
          ),
          ko: BookLocalization(
            title: '참된 행복을 찾아서',
            subtitle: 'In Search of True Happiness',
            author: '한국이슬람교 도서',
            lastRead: '1주 전 · 32쪽',
          ),
        ),
        BookMock(
          id: 'jesus-message',
          palette: BookPalette.sea,
          pages: 184,
          read: 0,
          langs: ['UZ', 'EN', 'KO'],
          uz: BookLocalization(
            title: 'Iso (a.s) ning haqiqiy xabari',
            subtitle: 'The True Message of Jesus Christ',
            author: 'Abu Ameenah Bilal Philips',
            lastRead: null,
          ),
          ko: BookLocalization(
            title: '예수 그리스도의 참 메시지',
            subtitle: 'The True Message of Jesus Christ',
            author: '빌람 필립스',
            lastRead: null,
          ),
        ),
        BookMock(
          id: 'illustrated',
          palette: BookPalette.night,
          pages: 64,
          read: 64,
          langs: ['UZ', 'KO'],
          uz: BookLocalization(
            title: "Islomga qisqa yoʻriq",
            subtitle: '이슬람의 이해를 돕는 안내서',
            author: 'I. A. Ibrahim',
            lastRead: null,
          ),
          ko: BookLocalization(
            title: '이슬람의 이해를 돕는 안내서',
            subtitle: 'A Brief Illustrated Guide to Islam',
            author: 'I. A. 이브라힘',
            lastRead: null,
          ),
        ),
      ];

  static BookMock byId(String id) => all.firstWhere(
        (b) => b.id == id,
        orElse: () => all.first,
      );

  /// Generic sample chapter shown when a non-Qur'an book is opened.
  /// Mirrors the design's "IV bob · Islom ustunlari" placeholder.
  static const BookReadingChapter sampleChapterUz = BookReadingChapter(
    title: 'IV bob · Islom ustunlari',
    paragraphs: [
      "Islom besh ustunga asoslanadi: shahodat, namoz, zakot, roʻza, va haj. "
          "Bular iymoning tashqi ifodasi va eʼtirofni hayotga aylantiruvchi "
          'amaliy ramka hisoblanadi.',
      "Birinchi ustun — shahodat. “Allohdan boshqa iloh yoʻq va Muhammad "
          "Uning elchisidir” deb chin yurakdan eʼtirof etish. Ushbu bir gap — "
          'musulmonlik hayotining ochiluvchi eshigidir.',
      "Mazkur eʼtirof orqali musulmon insoniy hayotini abadiy oʻzakka "
          "bogʻlab, vaqtinchalik narsalardan haqiqiy manbaga yuzlanadi. "
          "Qolgan toʻrt ustun esa shu iymonga koʻrinarli shakl beradi.",
    ],
  );

  static const BookReadingChapter sampleChapterKo = BookReadingChapter(
    title: '제 4장 · 이슬람의 기둥',
    paragraphs: [
      '이슬람은 다섯 기둥 위에 세워져 있습니다: 증언(샤하다), 예배(살라트), '
          '자선(자카트), 단식(사움), 그리고 성지 순례(하지). 이는 신앙의 외적 '
          '표현이자, 고백을 생활로 변환하는 실천적 틀입니다.',
      '첫 번째 기둥은 증언(샤하다)입니다. “알라 외에 다른 신이 없고 '
          '무함마드는 그의 사도이시다”라고 진심으로 선언하는 것입니다. '
          '이 한 문장이 무슬림으로서의 삶을 여는 문입니다.',
      '이 선언을 통해 무슬림은 강건한 것에 의지하는 삶을 선택하고, '
          '일시적인 것에서 영원한 것으로 방향을 돌립니다. 이어지는 네 기둥은 '
          '이 박음에 뚜렷한 형태를 부여합니다.',
    ],
  );

  /// Qur'an "currently reading" sample page — used by the reader when the
  /// user opens the Qur'an book card. Mirrors the design's READER_PAGES[0].
  static const QuranReadingPage quranSamplePage = QuranReadingPage(
    surahUz: 'Al-Baqara',
    surahKo: '바까라',
    surahArabic: 'البقرة',
    page: 24,
    juz: 2,
    ayahs: [
      QuranAyah(
        number: 153,
        arabic:
            'يَاأَيُّهَا الَّذِينَ آمَنُوا اسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ ، إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
        translationUz:
            "Ey iymon keltirganlar! Sabr va namoz orqali yordam soʻrang. "
            'Albatta, Alloh sabrlilar bilandir.',
        translationKo:
            '믿는 자들이여, 인내와 예배를 통해 도움을 구하라. 실로 '
            '알라는 인내하는 자들과 함께하신다.',
      ),
      QuranAyah(
        number: 154,
        arabic:
            'وَلَا تَقُولُوا لِمَنْ يُقْتَلُ فِي سَبِيلِ اللَّهِ أَمْوَاتٌ ، بَلْ أَحْيَاءٌ وَلَاكِنْ لَا تَشْعُرُونَ',
        translationUz:
            "Allohning yoʻlida oʻldirilganlarni “oʻliklar” demang. "
            "Yoʻq, ular tiriklar, lekin siz buni sezmaysiz.",
        translationKo:
            '알라의 길에서 살해된 자들을 “죽은 자”라고 말하지 말라. '
            '그들은 살아있다, 그러나 너희는 그것을 깨닫지 못한다.',
      ),
      QuranAyah(
        number: 155,
        arabic:
            'وَلَنَبْلُوَنَّكُمْ بِشَلْءٍ مِنَ الْخَوْفِ وَالْجُوعِ وَنَقْصٍ مِنَ الْأَمْوَالِ وَالْأَنْفُسِ وَالثَّمَرَاتِ ، وَبَشِّرِ الصَّابِرِينَ',
        translationUz:
            "Sizlarni qoʻrquv, ochlik, mol-mulk, jonlar va mevalardan "
            'ozaytirish bilan albatta sinaymiz. Sabr qiluvchilarga '
            'xushxabar ber.',
        translationKo:
            '너희를 두려움, 기아짐, 재산, 생명, 과실의 손실로 시험하리라. '
            '그리고 인내하는 자들에게 기쁜 소식을 전하라.',
      ),
    ],
  );
}

/// Book cover palette — fg/bg/sub colors match the design's PALETTES map.
enum BookPalette {
  quran(bg: Color(0xFF0F5132), fg: Color(0xFFEDD9A0), sub: Color(0xFFC9A961)),
  forest(bg: Color(0xFF1B3A2C), fg: Color(0xFFE8DCC2), sub: Color(0xFFC9A961)),
  sky(bg: Color(0xFFD8E3E8), fg: Color(0xFF1F3B4D), sub: Color(0xFF5C7A8C)),
  mist(bg: Color(0xFFE8E4D8), fg: Color(0xFF2A3530), sub: Color(0xFF7A8077)),
  teal(bg: Color(0xFF2A4A48), fg: Color(0xFFE8DCC2), sub: Color(0xFFC9A961)),
  sea(bg: Color(0xFF3D6F73), fg: Color(0xFFF4E9C9), sub: Color(0xFFC9A961)),
  night(bg: Color(0xFF1F2725), fg: Color(0xFFD8B870), sub: Color(0xFF8A7544));

  final Color bg;
  final Color fg;
  final Color sub;

  const BookPalette({required this.bg, required this.fg, required this.sub});
}

class BookLocalization {
  final String title;
  final String subtitle;
  final String author;

  /// Null for books that have never been opened.
  final String? lastRead;

  const BookLocalization({
    required this.title,
    required this.subtitle,
    required this.author,
    required this.lastRead,
  });
}

class BookMock {
  final String id;
  final BookPalette palette;
  final int pages;
  final int read;
  final List<String> langs;
  final BookLocalization uz;
  final BookLocalization ko;

  const BookMock({
    required this.id,
    required this.palette,
    required this.pages,
    required this.read,
    required this.langs,
    required this.uz,
    required this.ko,
  });

  /// Reads the locale-matched bundle, falling back to UZ for unsupported
  /// locales (en / ru / ar all share the UZ copy for now).
  BookLocalization localized(String localeCode) {
    return localeCode == 'ko' ? ko : uz;
  }

  double get progress => pages == 0 ? 0 : read / pages;

  int get progressPercent => (progress * 100).round();

  bool get isStarted => read > 0;

  bool get isFinished => read >= pages && pages > 0;
}

class BookReadingChapter {
  final String title;
  final List<String> paragraphs;

  const BookReadingChapter({required this.title, required this.paragraphs});
}

class QuranReadingPage {
  final String surahUz;
  final String surahKo;
  final String surahArabic;
  final int page;
  final int juz;
  final List<QuranAyah> ayahs;

  const QuranReadingPage({
    required this.surahUz,
    required this.surahKo,
    required this.surahArabic,
    required this.page,
    required this.juz,
    required this.ayahs,
  });

  String surahName(String localeCode) => localeCode == 'ko' ? surahKo : surahUz;
}

class QuranAyah {
  final int number;
  final String arabic;
  final String translationUz;
  final String translationKo;

  const QuranAyah({
    required this.number,
    required this.arabic,
    required this.translationUz,
    required this.translationKo,
  });

  String translation(String localeCode) =>
      localeCode == 'ko' ? translationKo : translationUz;
}
