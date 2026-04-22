import 'package:koreaislam/data/datasource/network/dto/article/agency_article_response.dart';
import 'package:koreaislam/data/datasource/network/services/article_service.dart';
import 'package:koreaislam/data/datasource/preference/profile_preferences.dart';
import 'package:koreaislam/data/mappers/article_mappers.dart';
import 'package:koreaislam/domain/models/article/published_article.dart';

class ArticleRepository {
  final ArticleService _articleService;
  // ignore: unused_field
  final ProfilePreferences _profilePreferences;

  ArticleRepository(
    this._articleService,
    this._profilePreferences,
  );

  Future<List<PublishedArticle>> fetchTopArticles() async {
    var response = await _articleService.fetchTopArticles();
    var rootResponse = AgencyRootArticleResponse.fromJson(response.data);

    return rootResponse.items
            ?.map((e) => PublishedArticle.from(e.toModel()))
            .toList() ??
        [];
  }

  Future<List<PublishedArticle>> fetchArticles({
    required int page,
    required int size,
  }) async {
    var response = await _articleService.fetchArticles(page: page, size: size);
    var rootResponse = AgencyRootArticleResponse.fromJson(response.data);

    return rootResponse.items
            ?.map((e) => PublishedArticle.from(e.toModel()))
            .toList() ??
        [];
  }

  Future<PublishedArticle> fetchArticleDetail({
    required int articleId,
  }) async {
    var response = await _articleService.fetchArticleDetail(
      articleId: articleId,
    );

    return PublishedArticle.from(
      AgencyArticleResponse.fromJson(response.data).toModel(),
    );
  }
}
