class AgencyArticle {
  int articleId;
  String title;
  String desc;
  List<String> photos;
  String mainPhoto;
  int viewedCount;
  int likedCount;
  int bookmarkedCount;
  int sharedCount;
  String createdAt;
  String? updatedAt;
  String? moderatorNote;

  AgencyArticle({
    required this.articleId,
    required this.title,
    required this.desc,
    required this.photos,
    required this.mainPhoto,
    required this.viewedCount,
    required this.likedCount,
    required this.bookmarkedCount,
    required this.sharedCount,
    required this.createdAt,
    this.updatedAt,
    this.moderatorNote,
  });
}
