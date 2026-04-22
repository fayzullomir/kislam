import 'dart:math';

import 'package:koreaislam/data/datasource/mock/common_mock_data_source.dart';
import 'package:koreaislam/domain/models/ad/partner_ad/partner_ads.dart';

class  AdRepository {
  AdRepository();

  Future<List<PartnerAd>> fetchPartnerAds() async {
    await Future.delayed(Duration(milliseconds: 1200));

    return CommonMockDataSource.partnerAds..shuffle(Random());
  }
}
