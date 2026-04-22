import 'package:koreaislam/data/datasource/mock/common_mock_data_source.dart';
import 'package:koreaislam/domain/models/guide/guide_category.dart';

class GuideRepository {
  GuideRepository();

  Future<List<GuideCategory>> fetchGuideCategories() async {
    await Future.delayed(Duration(milliseconds: 500));

    return CommonMockDataSource.guideCategories;
  }
}
