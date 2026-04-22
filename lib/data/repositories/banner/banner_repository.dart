import 'package:koreaislam/domain/models/banner/banner_image.dart';

class BannerRepository {
  BannerRepository();

  Future<List<BannerImage>> fetchBanners() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      BannerImage(imageUrl: "https://cdn6.aptoide.com/imgs/6/b/b/6bb64fd306660f64dd4848ff4e197762_fgraphic.png"),
      BannerImage(imageUrl: "https://media.cybernews.com/images/featured-big/2024/01/esim-for-international-travel.jpg"),
      BannerImage(imageUrl: "https://avatars.mds.yandex.net/get-altay/15629777/2a0000019900f20c03b4f1676fb0a42f32b1/L_height"),
    ];
  }
}
