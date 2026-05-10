import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/domain/models/ad/partner_ad/partner_ads.dart';
import 'package:koreaislam/domain/models/guide/guide_category.dart';

class CommonMockDataSource {
  static List<GuideCategory> get guideCategories => [
        GuideCategory(
          id: '1',
          name: "Safarga tayyorgarlik",
          icon: Assets.images.guideBag,
        ),
        GuideCategory(
          id: '2',
          name: "Samalyotda parvoz chog'ida",
          icon: Assets.images.guideAirPlane,
        ),
        GuideCategory(
          id: '3',
          name: "Mehmonxonada",
          icon: Assets.images.guideHotel,
        ),
        GuideCategory(
          id: '4',
          name: "Makkada",
          icon: Assets.images.guideMecca,
        ),
        GuideCategory(
          id: '5',
          name: "Madinada",
          icon: Assets.images.guideMedina,
        ),
        GuideCategory(
          id: '8',
          name: "Sog'liq va gigiyena",
          icon: Assets.images.guideMedical,
        ),
        GuideCategory(
          id: '10',
          name: "Favqulodda vaziyatlar",
          icon: Assets.images.guideCallMedicine,
        ),
        GuideCategory(
          id: '11',
          name: "Qaytish safariga tayyorgarlik",
          icon: Assets.images.guideGift,
        ),
        GuideCategory(
          id: '12',
          name: "Qo'shimcha maslahatlar",
          icon: Assets.images.guideAdditionalInfo,
        ),
      ];

  static List<PartnerAd> get partnerAds => [
        PartnerAd(
          adId: "ad1",
          productId: "product1",
          productName: "ODYSSEY 20 dyuymli chamadon",
          partnerName: "Tanvir.uz",
          partnerUrl:
              "https://tanvir.uz/product/%D1%87%D0%B5%D0%BC%D0%BE%D0%B4%D0%B0%D0%BD-odyssey-20inch/?srsltid=AfmBOop5PvcZQ0ZguCEXhboRnKC5gbaqjklZA6Ro7Tu4E1FIom8E-U81",
          brandName: "BAGSMART",
          adPhotos: [
            "https://tanvir.uz/wp-content/uploads/2024/10/TNBM0105008AN022-scaled.jpg",
            "https://tanvir.uz/wp-content/uploads/2024/10/TNBM0105008AN022-9-scaled.jpg",
            "https://tanvir.uz/wp-content/uploads/2024/10/TNBM0105008AN022-7-scaled.jpg",
            "https://tanvir.uz/wp-content/uploads/2024/10/TNBM0105008AN022-3-scaled.jpg",
          ],
          price: 1804320,
        ),
        PartnerAd(
          adId: "ad1231",
          productId: "product123",
          productName: "NIVEA Care yuz uchun krem, shi yog'i bilan, 100 ml",
          partnerName: "Uzum Market",
          partnerUrl:
              "https://uzum.uz/uz/product/nivea-care-yuz-uchun-krem-shi-21478?skuId=27084",
          brandName: "NIVEA",
          adPhotos: [
            "https://images.uzum.uz/d0rcn3on274j5scopjig/original.jpg",
          ],
          price: 49390,
        ),
        PartnerAd(
          adId: "ad1231",
          productId: "product123",
          productName:
              "Trimmer soch va soqol olish mashinkasi Geemy 3/1 GM-566",
          partnerName: "Uzum Market",
          partnerUrl:
              "https://uzum.uz/uz/product/trimmer-soch-va-1521404?skuId=4995098",
          brandName: "Geemy",
          adPhotos: [
            "https://images.uzum.uz/d07mdjmi4n37npaqica0/original.jpg",
          ],
          price: 83320,
        ),
        PartnerAd(
          adId: "ad-07098",
          productId: "product985658695",
          productName:
              "Ayollar sliponlari DISHER EasyStep, nafas oluvchi, yumshoq taglikli, 1 o‘lchamga kichik",
          partnerName: "Uzum Market",
          partnerUrl:
              "https://uzum.uz/uz/product/ayollar-sliponlari-disher-binafsha---130-1064310?skuId=3203960",
          brandName: "DISHER",
          adPhotos: [
            "https://images.uzum.uz/cv923hei4n36ls3ugo60/original.jpg",
          ],
          price: 84850,
        ),
        PartnerAd(
          adId: "ad457456",
          productId: "product123234",
          productName:
              "Aqlli fitness bilaguzuk Mi Band 9 Pro, global versiya, rus tili bilan",
          partnerName: "Uzum Market",
          partnerUrl:
              "https://uzum.uz/uz/product/aqlli-fitness-bilaguzuk-kumush-rang---4-1336363?skuId=4301910",
          brandName: "DISHER",
          adPhotos: [
            "https://images.uzum.uz/ct2vtadpb7f3jk80qth0/original.jpg",
          ],
          price: 911040,
        ),
        PartnerAd(
          adId: "ad2",
          productId: "product2",
          productName: "Ayollar kosmetik sumkasi",
          partnerName: "Uzum Market",
          partnerUrl:
              "https://uzum.uz/uz/product/ayollar-kosmetik-sumkasi-qora---1-1806513?skuId=6296121",
          brandName: "Femmy",
          adPhotos: [
            "https://images.uzum.uz/d22e33fiub3cuo9e6l60/original.jpg",
            "https://images.uzum.uz/d22e32j4eu2smlp68cs0/original.jpg",
            "https://images.uzum.uz/d22e32fiub3cuo9e6l5g/original.jpg",
          ],
          price: 134990,
        ),
        PartnerAd(
          adId: "ad3",
          productId: "product3",
          productName: "\"Cube\" chemodani",
          partnerName: "Chemodan.uz",
          partnerUrl: "https://chemodan.uz/products/10",
          brandName: "Femmy",
          adPhotos: [
            "https://chemodan.uz/images/9f09f964-801c-4173-ab92-b94a0a11e165.jpg",
            "https://chemodan.uz/images/6068a1cd-4123-4218-94be-392c49d4e9e7.jpg",
            "https://chemodan.uz/images/3c45b319-a313-48e5-8b70-8aabc086c9a7.jpg",
            "https://chemodan.uz/images/38497cfc-b618-4b29-ac47-530691fd08b8.jpg",
          ],
          price: 850000,
        ),
        PartnerAd(
          adId: "ad4",
          productId: "product4",
          productName: "Green massaj qiluvchi aparat",
          partnerName: "Elmakon.uz",
          partnerUrl:
              "https://elmakon.uz/bytovaya-tehnika-ru/gnfg2500mbl-massazher-green/",
          brandName: "Green",
          adPhotos: [
            "https://elmakon.uz/images/thumbnails/1200/1200/detailed/30/%D0%91%D0%B5%D0%B7_%D0%B8%D0%BC%D0%B5%D0%BD%D0%B8-2267.jpg",
          ],
          price: 349000,
        ),
      ];
}
