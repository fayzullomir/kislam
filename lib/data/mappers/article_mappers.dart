import 'package:koreaislam/data/datasource/network/dto/article/agency_article_response.dart';
import 'package:koreaislam/domain/models/article/agency_article.dart';

extension AgencyArticleResponseMappers on AgencyArticleResponse {
  AgencyArticle toModel() {
    return AgencyArticle(
      articleId: id,
      title: title ?? "",
      desc: description ?? "",
      photos: photos ?? [],
      mainPhoto: photos?.firstOrNull ?? "",
      likedCount: likeCount ?? 0,
      viewedCount: viewCount ?? 0,
      sharedCount: sharedCount ?? 0,
      bookmarkedCount: 0,
      createdAt: createdAt ?? "",
      updatedAt: updatedAt ?? "",
    );
  }
}
