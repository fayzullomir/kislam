import 'package:dio/dio.dart';

class ArticleService {
  final Dio bearerAuth;
  final Dio withoutAuth;

  ArticleService({
    required this.bearerAuth,
    required this.withoutAuth,
  });

  Future<Response> fetchTopArticles({
    int page = 1,
    int size = 10,
  }) async {
    final queryParams = {
      "page": page,
      "per_page": size,
    };
    var response = await bearerAuth.get(
      "mobile/post/",
      queryParameters: queryParams,
    );

    return response;
  }

  Future<Response> fetchArticles({
    required int page,
    required int size,
  }) async {
    final queryParams = {
      "page": page,
      "per_page": size,
    };
    var response = await bearerAuth.get(
      "mobile/post/",
      queryParameters: queryParams,
    );

    return response;
  }

  Future<Response> fetchArticleDetail({
    required int articleId,
  }) async {
    var response = await bearerAuth.get(
      "mobile/post/$articleId",
    );

    return response;
  }
}
