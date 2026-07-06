/// Islamic terms ("Atamalar") mock data — mirrors the standalone design's
/// TERMS list and TERM_CATS map. Locale-aware name / short / long strings
/// live inline so the terms tab can render without hitting easy_localization
/// for content (only chrome strings flow through Strings).
class TermsMockData {
  TermsMockData._();

  static List<TermMock> get all => const [
        // ----- Fiqh hukmlari -----
        TermMock(
          id: 'farz',
          arabic: 'فرض',
          category: TermCategory.fiqh,
          uz: TermLocalization(
            name: 'Farz',
            short: 'Majburiy amal',
            long: "Alloh tomonidan qatʼiy buyurilgan amallar. "
                'Bajarmaslik gunoh hisoblanadi va inkor qilish kufrga '
                'olib boradi. Misol: kunlik besh vaqt namoz, Ramazon '
                "roʻzasi, zakot, haj.",
          ),
          ko: TermLocalization(
            name: '파르드',
            short: '필수 행위',
            long: '알라에 의해 엄격히 명령된 행위. 실행하지 않으면 죄가 되며, '
                '부정하면 배교로 이어지는 심각한 행위입니다. 예: 매일 '
                '다섯 번의 예배, 라마단 단식, 자카트, 성지 순례.',
          ),
        ),
        TermMock(
          id: 'vojib',
          arabic: 'واجب',
          category: TermCategory.fiqh,
          uz: TermLocalization(
            name: 'Vojib',
            short: 'Yarim majburiy',
            long: 'Hanafiy fiqhida farzga yaqin, lekin dalili biroz '
                "zaifroq boʻlgan buyruqlar. Bajarmaslik gunoh, ammo "
                'inkor kufr emas. Misol: vitr namozi, Hayit namozi, '
                'qurbonlik.',
          ),
          ko: TermLocalization(
            name: '와집브',
            short: '준필수',
            long: '하나피 피크흐에서 파르드에 가깝지만 근거가 다소 약한 명령. '
                '실행하지 않으면 죄가 되지만 배교로 연결되지는 않습니다. '
                '예: 위트르 예배, 이드 예배.',
          ),
        ),
        TermMock(
          id: 'sunnat',
          arabic: 'سنة',
          category: TermCategory.fiqh,
          uz: TermLocalization(
            name: 'Sunnat',
            short: "Paygʻambar amallari",
            long: "Paygʻambarimiz Muhammad (s.a.v.)ning soʻzlari, amallari "
                'va taqdirlangan ishlari. Bajarish savobli, lekin tark '
                'qilish gunoh emas. Misol: misvok ishlatish, peshindan '
                'oldin 4 rakat sunnat, ehson.',
          ),
          ko: TermLocalization(
            name: '순나',
            short: '예언자의 행동',
            long: '예언자 무함마드(그에게 평화가 있길)의 말, 행동, 그리고 '
                '승인한 일들. 실천하면 보상이 있지만, 버려도 죄가 '
                '되지는 않습니다. 예: 미스와크 사용, 선행.',
          ),
        ),
        TermMock(
          id: 'mustahab',
          arabic: 'مستحب',
          category: TermCategory.fiqh,
          uz: TermLocalization(
            name: 'Mustahab',
            short: 'Tavsiya etilgan',
            long: "Sevimli koʻrilgan, ammo majburiy boʻlmagan amallar. "
                'Bajaruvchi savob oladi, tark qiluvchi gunohkor emas. '
                "Misol: ortiqcha nafl namozlar, sadaqa, Qurʼon yodlash.",
          ),
          ko: TermLocalization(
            name: '무스타함브',
            short: '권장 사항',
            long: '사랑받지만 필수는 아닌 행위. 실행하면 보상을 받고, 하지 '
                '않아도 죄가 되지 않습니다. 예: 보충 예배, 자선, 꾸란 '
                '암기.',
          ),
        ),
        TermMock(
          id: 'mubah',
          arabic: 'مباح',
          category: TermCategory.fiqh,
          uz: TermLocalization(
            name: 'Mubah',
            short: 'Ruxsat etilgan',
            long: 'Bajarish ham tark qilish ham bir xil — savob ham gunoh '
                "ham yoʻq. Bularning aksariyati kundalik dunyoviy "
                "ishlardir: ovqat, kiyim, koʻngilochar mashgʻulotlar "
                '(taqiqlanmagan).',
          ),
          ko: TermLocalization(
            name: '무바흐',
            short: '허용',
            long: '했든 안 했든 동일 — 보상도 죄도 없는 행위. 대부분 일상의 '
                '세속적인 일들입니다: 식사, 옷, 허용된 오락.',
          ),
        ),
        TermMock(
          id: 'makruh',
          arabic: 'مكروه',
          category: TermCategory.fiqh,
          uz: TermLocalization(
            name: 'Makruh',
            short: 'Yoqimsiz',
            long: 'Taqiqlangan emas, lekin Allohga yoqmaydigan amallar. '
                'Tark qilish savobli, qilish ozgina gunoh keltirishi '
                "mumkin. Misol: chap qoʻl bilan ovqatlanish, masjidda "
                "ovoz koʻtarish.",
          ),
          ko: TermLocalization(
            name: '마크루흐',
            short: '기피 행위',
            long: '금지되지는 않지만 알라가 싫어하시는 행위. 버리면 보상이 '
                '있고, 했을 때 경미한 죄가 될 수 있습니다. 예: 왼손으로 '
                '먹기.',
          ),
        ),
        TermMock(
          id: 'haram',
          arabic: 'حرام',
          category: TermCategory.fiqh,
          uz: TermLocalization(
            name: 'Haram',
            short: 'Taqiqlangan',
            long: "Allohning qatʼiy taqiqi. Bajarish katta gunoh, halol deb "
                "hisoblash kufrga olib keladi. Misol: choʻchqa goʻshti, "
                'alkogol, zino, ribo (foiz).',
          ),
          ko: TermLocalization(
            name: '하람',
            short: '금지',
            long: '알라의 엄격한 금지. 실행하면 큰 죄이며, 허용된다고 '
                '여기면 배교로 이어집니다. 예: 돼지고기, 알코올, 간음, '
                '이자.',
          ),
        ),
        // ----- Ibodat -----
        TermMock(
          id: 'taxorat',
          arabic: 'طهارة',
          category: TermCategory.ibodat,
          uz: TermLocalization(
            name: 'Taxorat',
            short: 'Tahorat — ibodatga tayyorgarlik',
            long: 'Namoz va boshqa ibodatlar oldidan badan va kiyim toza '
                "boʻlishini taʼminlash. Tahoratning ikki turi: kichik "
                "(vuzuʼ) va katta (gʻusl). Suv boʻlmasa tayammum "
                '(tuproq bilan) qilinadi.',
          ),
          ko: TermLocalization(
            name: '타하라트',
            short: '의례적 정결',
            long: '예배나 다른 의식 전 몸과 옷이 깨끗한 상태임을 확실히 '
                '하는 일. 소정(와두)과 대정(구슬)의 두 종류가 있습니다. '
                '물이 없을 때는 타야뭄(흙으로 하는 정결)이 허용됩니다.',
          ),
        ),
        TermMock(
          id: 'vuzu',
          arabic: 'وضوء',
          category: TermCategory.ibodat,
          uz: TermLocalization(
            name: "Vuzuʼ",
            short: 'Kichik tahorat',
            long: "Yuz, qoʻllar (tirsakgacha), boshning bir qismi va "
                "oyoqlarni (toʻpigʻgacha) belgilangan tartibda yuvish. "
                "Har namoz oldidan, agar buzilgan boʻlsa, qaytarish "
                'kerak.',
          ),
          ko: TermLocalization(
            name: '와두',
            short: '소정',
            long: '얼굴, 팔꿈치까지의 손과 팔, 머리의 일부, 그리고 발목까지의 '
                '발을 정해진 순서대로 씻는 의식. 예배 전 필요하며, '
                '무효화되면 다시 해야 합니다.',
          ),
        ),
        TermMock(
          id: 'gusl',
          arabic: 'غسل',
          category: TermCategory.ibodat,
          uz: TermLocalization(
            name: "Gʻusl",
            short: 'Katta tahorat',
            long: 'Butun badanni suv bilan yuvib chiqish. Janoba '
                '(jinsiy nopoklik), hayz va nifosdan keyin majburiy. '
                'Bayram kunlari, juma namozidan oldin ham tavsiya '
                'etiladi.',
          ),
          ko: TermLocalization(
            name: '구슬로',
            short: '대정',
            long: '온몸을 물로 씻는 일. 잔나바(성적 부정), 월경, 출산 후 '
                '필수입니다. 명절과 금요일 예배 전에도 권장됩니다.',
          ),
        ),
        TermMock(
          id: 'niyat',
          arabic: 'نية',
          category: TermCategory.ibodat,
          uz: TermLocalization(
            name: 'Niyat',
            short: 'Ichki maqsad',
            long: 'Har bir ibodatning qalbidagi ichki niyati. '
                "Paygʻambar (s.a.v.) aytdilar: “Amallar niyatlarga qarab "
                'baholanadi.” Ovoz chiqarib aytish shart emas — '
                'qalbingizdagi maqsad muhim.',
          ),
          ko: TermLocalization(
            name: '니야',
            short: '내면의 의도',
            long: '모든 예배의 마음속 의도. 예언자께서 말씀하셨습니다: '
                '“행위는 의도에 따라 평가된다.” 소리 내어 말하지 않아도 '
                '됩니다 — 마음속 의도가 중요합니다.',
          ),
        ),
        TermMock(
          id: 'azon',
          arabic: 'أذان',
          category: TermCategory.ibodat,
          uz: TermLocalization(
            name: 'Azon',
            short: 'Namozga chaqirish',
            long: 'Namoz vaqti kirganligi haqida muazzin tomonidan '
                'ovozli chaqiriq. “Allohu Akbar” bilan boshlanadi. '
                'Koreyada masjidlar tashqi azonni kamdan-kam '
                'chiqarsa-da, ilovaning azon bildirishnomasini yoqib '
                "qoʻyishingiz mumkin.",
          ),
          ko: TermLocalization(
            name: '아단',
            short: '예배 소집',
            long: '예배 시간이 되었음을 알리는 무앋진의 소리 부름. '
                '“알라후 아크바르”로 시작됩니다. 한국에서는 외부 '
                '스피커로 사용되는 경우가 적지만, 앱 알림을 켜실 수 '
                '있습니다.',
          ),
        ),
        TermMock(
          id: 'rakat',
          arabic: 'ركعة',
          category: TermCategory.ibodat,
          uz: TermLocalization(
            name: 'Rakat',
            short: 'Namoz birligi',
            long: 'Bir takbir, qiyom (tik turish), ruku (egilish), '
                "sajda (yer oʻpish) va oʻtirishdan iborat namoz "
                'birligi. Bomdod 2 rakat, peshin 4, asr 4, shom 3, '
                'xufton 4 rakatdan iborat.',
          ),
          ko: TermLocalization(
            name: '라카트',
            short: '예배 단위',
            long: '한 번의 타크비르, 기앍, 루쿠(숭임), 지륽(판드림), 앚기로 '
                '구성된 예배 단위. 파즈르 2, 드후르 4, 아스르 4, '
                '마그리브 3, 이샤 4 라카트입니다.',
          ),
        ),
        TermMock(
          id: 'kibla',
          arabic: 'قبلة',
          category: TermCategory.ibodat,
          uz: TermLocalization(
            name: 'Kibla',
            short: "Namoz yoʻnalishi",
            long: "Makkadagi Kaʼba tomon yoʻnalish. Har bir musulmon shu "
                "yoʻnalishga qarab namoz oʻqiydi. Koreya Oʻzbekistondan "
                "janub-gʻarbda — kompas bilan yoki K-Islam ilovasi "
                'yordamida aniqlanadi.',
          ),
          ko: TermLocalization(
            name: '키블라',
            short: '예배 방향',
            long: '메카의 카아바 방향. 모든 무슬림은 이 방향을 향해 예배를 '
                '드립니다. 한국에서는 서남쪽입니다 — 나침반이나 K-Islam '
                '앱으로 확인할 수 있습니다.',
          ),
        ),
        TermMock(
          id: 'zakot',
          arabic: 'زكاة',
          category: TermCategory.ibodat,
          uz: TermLocalization(
            name: 'Zakot',
            short: 'Majburiy sadaqa',
            long: "Islom ustunlaridan biri. Yiliga bir marta toʻplangan "
                'mol-mulkning 2.5 foizini muhtojlarga berish. Sof '
                'boylik nisab (taxminan 87.5 g oltin qiymati)dan '
                "oshganda majburiy boʻladi.",
          ),
          ko: TermLocalization(
            name: '자카트',
            short: '의무적 자선',
            long: '이슬람의 다섯 기둥 중 하나. 연 1회 소유 재산의 2.5%를 '
                '가난한 이에게 주는 일. 지산이 니사브(약 87.5g의 금 '
                '가치)를 넘으면 의무가 됩니다.',
          ),
        ),
        TermMock(
          id: 'roza',
          arabic: 'صوم',
          category: TermCategory.ibodat,
          uz: TermLocalization(
            name: "Roʻza",
            short: "Saum — Ramazon roʻzasi",
            long: 'Tongdan kun botgunga qadar ovqat, ichimlik va boshqa '
                'cheklangan amallardan saqlanish. Ramazon oyida farz, '
                "boshqa kunlarda nafl (ixtiyoriy) boʻladi.",
          ),
          ko: TermLocalization(
            name: '로자',
            short: '사움 — 라마단 단식',
            long: '새벽부터 일몰까지 음식, 음료 및 기타 제한된 행위를 '
                '삼가는 일. 라마단 달에는 파르드, 다른 날에는 선택사항입니다.',
          ),
        ),
      ];

  static TermMock byId(String id) =>
      all.firstWhere((t) => t.id == id, orElse: () => all.first);

  /// Display order in the filter chip row. `all` is always first.
  static const List<TermCategory> filterOrder = [
    TermCategory.all,
    TermCategory.fiqh,
    TermCategory.ibodat,
  ];
}

enum TermCategory { all, fiqh, ibodat }

class TermLocalization {
  final String name;
  final String short;
  final String long;

  const TermLocalization({
    required this.name,
    required this.short,
    required this.long,
  });
}

class TermMock {
  final String id;
  final String arabic;
  final TermCategory category;
  final TermLocalization uz;
  final TermLocalization ko;

  const TermMock({
    required this.id,
    required this.arabic,
    required this.category,
    required this.uz,
    required this.ko,
  });

  TermLocalization localized(String localeCode) =>
      localeCode == 'ko' ? ko : uz;
}
