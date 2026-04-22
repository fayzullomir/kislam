import 'package:koreaislam/domain/models/article/agency_article.dart';

class PublishedArticle {
  int articleId;
  String title;
  String desc;
  String mainPhoto;
  List<String> photos;
  int viewedCount;
  String createdAt;
  bool isLiked;
  bool isBookmarked;

  PublishedArticle({
    required this.articleId,
    required this.title,
    required this.desc,
    required this.mainPhoto,
    required this.photos,
    required this.viewedCount,
    required this.createdAt,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  static PublishedArticle from(AgencyArticle article) {
    return PublishedArticle(
      articleId: article.articleId,
      title: article.title,
      desc: article.desc,
      mainPhoto: article.mainPhoto,
      photos: article.photos,
      viewedCount: article.viewedCount,
      createdAt: article.createdAt,
    );
  }
}
