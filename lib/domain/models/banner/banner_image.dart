class BannerImage {
  final int id;
  final String imageUrl;
  final String actionTitle;
  final String actionType;
  final String actionData;

  BannerImage({
    this.id = 0,
    required this.imageUrl,
    this.actionTitle = "",
    this.actionType = "",
    this.actionData = "",
  });
}
