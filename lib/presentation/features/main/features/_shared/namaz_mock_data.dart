/// Namoz mock data — mirrors the design's NAMAZ list (9 prayer types,
/// each with 1..N rakat-count variants). Locale-aware name strings live
/// inline so the list/detail screens can render without going through
/// easy_localization for content.
class NamazMockData {
  NamazMockData._();

  static List<NamazMock> get all => const [
        NamazMock(
          id: 'fajr',
          arabic: 'الفجر',
          uz: 'Bomdod namozi',
          ko: '파즈르 예배',
          timeUz: 'Saharda',
          timeKo: '새벽',
          variants: [
            NamazVariant(
              id: 'sunnat',
              uz: '2 rakat sunnat',
              ko: '2 라카트 순나',
              rakats: 2,
              kind: NamazVariantKind.sunnat,
            ),
            NamazVariant(
              id: 'farz',
              uz: '2 rakat farz',
              ko: '2 라카트 파르드',
              rakats: 2,
              kind: NamazVariantKind.farz,
            ),
          ],
        ),
        NamazMock(
          id: 'dhuhr',
          arabic: 'الظهر',
          uz: 'Peshin namozi',
          ko: '드후르 예배',
          timeUz: 'Tushdan keyin',
          timeKo: '정오',
          variants: [
            NamazVariant(
              id: 'sunnat-pre',
              uz: '4 rakat sunnat',
              ko: '4 라카트 순나',
              rakats: 4,
              kind: NamazVariantKind.sunnat,
            ),
            NamazVariant(
              id: 'farz',
              uz: '4 rakat farz',
              ko: '4 라카트 파르드',
              rakats: 4,
              kind: NamazVariantKind.farz,
            ),
            NamazVariant(
              id: 'sunnat-post',
              uz: '2 rakat sunnat',
              ko: '2 라카트 순나',
              rakats: 2,
              kind: NamazVariantKind.sunnat,
            ),
          ],
        ),
        NamazMock(
          id: 'asr',
          arabic: 'العصر',
          uz: 'Asr namozi',
          ko: '아스르 예배',
          timeUz: 'Kun yarmidan keyin',
          timeKo: '오후',
          variants: [
            NamazVariant(
              id: 'farz',
              uz: '4 rakat farz',
              ko: '4 라카트 파르드',
              rakats: 4,
              kind: NamazVariantKind.farz,
            ),
          ],
        ),
        NamazMock(
          id: 'maghrib',
          arabic: 'المغرب',
          uz: 'Shom namozi',
          ko: '마그리브 예배',
          timeUz: 'Kun botganda',
          timeKo: '일몰',
          variants: [
            NamazVariant(
              id: 'farz',
              uz: '3 rakat farz',
              ko: '3 라카트 파르드',
              rakats: 3,
              kind: NamazVariantKind.farz,
            ),
            NamazVariant(
              id: 'sunnat',
              uz: '2 rakat sunnat',
              ko: '2 라카트 순나',
              rakats: 2,
              kind: NamazVariantKind.sunnat,
            ),
          ],
        ),
        NamazMock(
          id: 'isha',
          arabic: 'العشاء',
          uz: 'Xufton namozi',
          ko: '이샤 예배',
          timeUz: 'Tunda',
          timeKo: '밤',
          variants: [
            NamazVariant(
              id: 'farz',
              uz: '4 rakat farz',
              ko: '4 라카트 파르드',
              rakats: 4,
              kind: NamazVariantKind.farz,
            ),
            NamazVariant(
              id: 'sunnat',
              uz: '2 rakat sunnat',
              ko: '2 라카트 순나',
              rakats: 2,
              kind: NamazVariantKind.sunnat,
            ),
            NamazVariant(
              id: 'vitr',
              uz: '3 rakat vitr',
              ko: '3 라카트 위트르',
              rakats: 3,
              kind: NamazVariantKind.vitr,
            ),
          ],
        ),
        NamazMock(
          id: 'juma',
          arabic: 'الجمعة',
          uz: 'Juma namozi',
          ko: '주마 예배',
          timeUz: 'Juma kuni',
          timeKo: '금요일',
          variants: [
            NamazVariant(
              id: 'sunnat-pre',
              uz: '4 rakat sunnat',
              ko: '4 라카트 순나',
              rakats: 4,
              kind: NamazVariantKind.sunnat,
            ),
            NamazVariant(
              id: 'farz',
              uz: '2 rakat farz',
              ko: '2 라카트 파르드',
              rakats: 2,
              kind: NamazVariantKind.farz,
            ),
            NamazVariant(
              id: 'sunnat-post',
              uz: '4 rakat sunnat',
              ko: '4 라카트 순나',
              rakats: 4,
              kind: NamazVariantKind.sunnat,
            ),
          ],
        ),
        NamazMock(
          id: 'janoza',
          arabic: 'صلاة الجنازة',
          uz: 'Janoza namozi',
          ko: '장례 예배',
          timeUz: 'Vafot etganga',
          timeKo: '고인을 위해',
          variants: [
            NamazVariant(
              id: 'takbir',
              uz: '4 takbir',
              ko: '4 타크비르',
              rakats: 0,
              kind: NamazVariantKind.janoza,
            ),
          ],
        ),
        NamazMock(
          id: 'istixora',
          arabic: 'صلاة الاستخارة',
          uz: 'Istixora namozi',
          ko: '이스티카라 예배',
          timeUz: 'Qaror oldidan',
          timeKo: '선택 전',
          variants: [
            NamazVariant(
              id: 'r2',
              uz: '2 rakat',
              ko: '2 라카트',
              rakats: 2,
              kind: NamazVariantKind.nafl,
            ),
          ],
        ),
        NamazMock(
          id: 'hojat',
          arabic: 'صلاة الحاجة',
          uz: 'Hojat namozi',
          ko: '하자트 예배',
          timeUz: 'Tilak uchun',
          timeKo: '소원을 위해',
          variants: [
            NamazVariant(
              id: 'r2',
              uz: '2 rakat',
              ko: '2 라카트',
              rakats: 2,
              kind: NamazVariantKind.nafl,
            ),
          ],
        ),
      ];

  static NamazMock byId(String id) => all.firstWhere(
        (n) => n.id == id,
        orElse: () => all.first,
      );

  /// Builds the ordered list of step keys for a given variant.
  /// Mirrors the design's `stepKeys` array construction.
  static List<NamazStepKey> stepKeysFor(NamazVariant variant) {
    if (variant.kind == NamazVariantKind.janoza) {
      return const [
        NamazStepKey.niyat,
        NamazStepKey.janazaTakbir,
        NamazStepKey.salom,
      ];
    }
    final keys = <NamazStepKey>[
      NamazStepKey.azon,
      NamazStepKey.niyat,
      NamazStepKey.takbir,
      NamazStepKey.qiyom,
      NamazStepKey.ruku,
      NamazStepKey.iqomat,
      NamazStepKey.sajda,
      NamazStepKey.jalsa,
      NamazStepKey.sajda,
      NamazStepKey.rakat2,
      NamazStepKey.tashahhud,
    ];
    if (variant.rakats >= 3) keys.add(NamazStepKey.rakat2);
    if (variant.rakats >= 4) keys.add(NamazStepKey.rakat2);
    keys.add(NamazStepKey.durud);
    keys.add(NamazStepKey.salom);
    return keys;
  }
}

enum NamazVariantKind { sunnat, farz, vitr, janoza, nafl }

class NamazVariant {
  final String id;
  final String uz;
  final String ko;
  final int rakats;
  final NamazVariantKind kind;

  const NamazVariant({
    required this.id,
    required this.uz,
    required this.ko,
    required this.rakats,
    required this.kind,
  });

  String localized(String localeCode) => localeCode == 'ko' ? ko : uz;
}

class NamazMock {
  final String id;
  final String arabic;
  final String uz;
  final String ko;
  final String timeUz;
  final String timeKo;
  final List<NamazVariant> variants;

  const NamazMock({
    required this.id,
    required this.arabic,
    required this.uz,
    required this.ko,
    required this.timeUz,
    required this.timeKo,
    required this.variants,
  });

  String localized(String localeCode) => localeCode == 'ko' ? ko : uz;
  String timeLocalized(String localeCode) =>
      localeCode == 'ko' ? timeKo : timeUz;
}

/// Step in the rakat sequence. Re-used inside the `NamazDetailPage`
/// step list. Each enum value maps to a [NamazStepContent] via the
/// [NamazStepCopy] map.
enum NamazStepKey {
  azon,
  niyat,
  takbir,
  qiyom,
  ruku,
  iqomat,
  sajda,
  jalsa,
  rakat2,
  tashahhud,
  durud,
  salom,
  janazaTakbir,
}

/// Pose figure variants — matches PoseFigure switch in the standalone
/// design (`standing`, `takbir`, `qiyom`, `ruku`, `sajda`, `jalsa`,
/// `tashahhud`, `salom`).
enum NamazPose { standing, takbir, qiyom, ruku, sajda, jalsa, tashahhud, salom }

class NamazStepContent {
  final String title;

  /// Body text. Some steps (niyat) embed the prayer name + variant —
  /// caller passes the values via [NamazStepCopy.contentFor].
  final String body;
  final NamazPose? pose;

  /// True for steps that link out to a term (azon, niyat).
  final bool hasMoreLink;

  const NamazStepContent({
    required this.title,
    required this.body,
    required this.pose,
    this.hasMoreLink = false,
  });
}

/// Copy bundle for one locale. Returns a [NamazStepContent] keyed by
/// step. Niyat in particular needs runtime composition because the
/// prayer name + variant flow into the body string.
class NamazStepCopy {
  final String locale;

  const NamazStepCopy(this.locale);

  bool get isKo => locale == 'ko';

  NamazStepContent contentFor(
    NamazStepKey key, {
    required String prayerName,
    required String variantName,
  }) {
    if (isKo) return _koContent(key, prayerName, variantName);
    return _uzContent(key, prayerName, variantName);
  }

  NamazStepContent _uzContent(
    NamazStepKey key,
    String prayerName,
    String variantName,
  ) {
    switch (key) {
      case NamazStepKey.azon:
        return const NamazStepContent(
          title: 'Azon',
          body: 'Namoz vaqti kirganda qiblaga yuzlanib azon aytiladi. '
              'Yaqinda azon ovozini eshitsangiz, javob qaytarish '
              'sunnatdir.',
          pose: null,
          hasMoreLink: true,
        );
      case NamazStepKey.niyat:
        return NamazStepContent(
          title: 'Niyat',
          body:
              "$prayerName ning $variantName ini ado qilishni niyat qildim. "
              "Allohim, O'zingning roziliging uchun.",
          pose: NamazPose.standing,
          hasMoreLink: true,
        );
      case NamazStepKey.takbir:
        return const NamazStepContent(
          title: 'Takbir',
          body: '«Allohu akbar» — ikki '
              "qo'lingni quloqlarga teng ko'tar va belingga tushir.",
          pose: NamazPose.takbir,
        );
      case NamazStepKey.qiyom:
        return const NamazStepContent(
          title: 'Qiyom',
          body: '«Sano» duosi → Fotiha surasi → Zam sura.',
          pose: NamazPose.qiyom,
        );
      case NamazStepKey.ruku:
        return const NamazStepContent(
          title: 'Ruku',
          body: '«Allohu akbar» deb beligacha egilib, '
              '«Subhana Robbiyal Azim» ni 3 marta ayt.',
          pose: NamazPose.ruku,
        );
      case NamazStepKey.iqomat:
        return const NamazStepContent(
          title: "Qaddini ko'tarish",
          body: '«Samiallohu liman hamidah» deb tik turib '
              '«Robbana lakal hamd» ayt.',
          pose: NamazPose.standing,
        );
      case NamazStepKey.sajda:
        return const NamazStepContent(
          title: 'Sajda',
          body: "«Allohu akbar» deb yerga — peshana, burun, ikki qo'l, "
              'ikki tizza, ikki oyoq uchi yerga. '
              "«Subhana Robbiyal A'la» 3 marta.",
          pose: NamazPose.sajda,
        );
      case NamazStepKey.jalsa:
        return const NamazStepContent(
          title: 'Sajdadan turish',
          body: "«Allohu akbar» deb chap oyoq ustiga o'tirib bir muddat "
              "tinch o'tir.",
          pose: NamazPose.jalsa,
        );
      case NamazStepKey.rakat2:
        return const NamazStepContent(
          title: 'Keyingi rakat',
          body: '«Allohu akbar» deb tik tur, Fotiha + Zam sura, ruku, '
              'ikki sajda — yuqoridagidek.',
          pose: NamazPose.qiyom,
        );
      case NamazStepKey.tashahhud:
        return const NamazStepContent(
          title: 'Tashahhud',
          body: "Tashahhud (Attahiyatu...) o'qiladi. "
              "Ko'rsatkich barmoq Shahodatda ko'tariladi.",
          pose: NamazPose.tashahhud,
        );
      case NamazStepKey.durud:
        return const NamazStepContent(
          title: "Durud va Du'o",
          body: "Salovat (Allohumma salli...) va istalgan du'o.",
          pose: NamazPose.tashahhud,
        );
      case NamazStepKey.salom:
        return const NamazStepContent(
          title: 'Salom',
          body: '«Assalamu alaykum va rohmatulloh» — boshni avval '
              "o'ngga, keyin chapga burib salom ber.",
          pose: NamazPose.salom,
        );
      case NamazStepKey.janazaTakbir:
        return const NamazStepContent(
          title: '4 Takbir',
          body: 'Imom 4 marta «Allohu akbar» aytadi. Har takbirdan '
              "keyin tilovat, salovat, vafot etganga du'o, oxirida salom.",
          pose: NamazPose.qiyom,
        );
    }
  }

  NamazStepContent _koContent(
    NamazStepKey key,
    String prayerName,
    String variantName,
  ) {
    switch (key) {
      case NamazStepKey.azon:
        return const NamazStepContent(
          title: '아단',
          body: '예배 시간이 되면 키블라를 향해 아단을 부릅니다. 근처에서 '
              '아단 소리가 들리면 대답하는 것이 순나입니다.',
          pose: null,
          hasMoreLink: true,
        );
      case NamazStepKey.niyat:
        return NamazStepContent(
          title: '니야',
          body: '$prayerName 의 $variantName 를 드리고자 마음으로 정합니다. '
              '알라의 기민을 위해.',
          pose: NamazPose.standing,
          hasMoreLink: true,
        );
      case NamazStepKey.takbir:
        return const NamazStepContent(
          title: '타크비르',
          body: '“알라후 아크바르” 두 손을 귀와 평행하게 올렸다가 허리에 '
              '내립니다.',
          pose: NamazPose.takbir,
        );
      case NamazStepKey.qiyom:
        return const NamazStepContent(
          title: '기앍 (Qiyom)',
          body: '“사나” 두아 → 파티하 장 → 추가 장.',
          pose: NamazPose.qiyom,
        );
      case NamazStepKey.ruku:
        return const NamazStepContent(
          title: '루쿠 (숭임)',
          body: '“알라후 아크바르”로 허리까지 숭이고 “서브하나 로비야알 '
              '아지임”을 3번 말합니다.',
          pose: NamazPose.ruku,
        );
      case NamazStepKey.iqomat:
        return const NamazStepContent(
          title: '직립',
          body: '“샤미알라후 리만 함미다”로 다시 서고 “로바나 라카람흒드”를 '
              '말합니다.',
          pose: NamazPose.standing,
        );
      case NamazStepKey.sajda:
        return const NamazStepContent(
          title: '지륽 (사즈다)',
          body: '“알라후 아크바르” 바닥에 이마·코·엇손·무릎·발가락을 대어 '
              '“서브하나 로비야알 아라” 3번.',
          pose: NamazPose.sajda,
        );
      case NamazStepKey.jalsa:
        return const NamazStepContent(
          title: '잘사',
          body: '“알라후 아크바르” 왼발 위에 앚아 잠시 간격을 둘니다.',
          pose: NamazPose.jalsa,
        );
      case NamazStepKey.rakat2:
        return const NamazStepContent(
          title: '다음 라카트',
          body: '“알라후 아크바르” 다시 서서 파티하 + 추가 장, 루쿠, 두 '
              '지륽 — 상안과 동일.',
          pose: NamazPose.qiyom,
        );
      case NamazStepKey.tashahhud:
        return const NamazStepContent(
          title: '타썌후드',
          body: '타썌후드(알타히야투…)를 낭송합니다. 샤하다에서 '
              '검지소가락을 올립니다.',
          pose: NamazPose.tashahhud,
        );
      case NamazStepKey.durud:
        return const NamazStepContent(
          title: '두루드 및 두아',
          body: '살라와트(알라후마 살리...)과 원하는 두아.',
          pose: NamazPose.tashahhud,
        );
      case NamazStepKey.salom:
        return const NamazStepContent(
          title: '살람',
          body: '“쥜살람 알라이쿬 와 라흐마툮로흐” — 고개를 오른쪽과 '
              '왼쪽으로 돌려 인사합니다.',
          pose: NamazPose.salom,
        );
      case NamazStepKey.janazaTakbir:
        return const NamazStepContent(
          title: '4 타크비르',
          body: '이맘이 “알라후 아크바르”를 4번 왜칩니다. 각 타크비르 후 '
              '낭송, 살라와트, 고인을 위한 두아, 마지막에 살람.',
          pose: NamazPose.qiyom,
        );
    }
  }
}
