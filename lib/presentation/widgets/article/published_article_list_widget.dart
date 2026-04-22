import 'package:flutter/material.dart';
import 'package:koreaislam/domain/models/article/published_article.dart';
import 'package:koreaislam/presentation/widgets/article/published_article_widget.dart';
import 'package:koreaislam/presentation/widgets/responsive/responsive_builder.dart';

class PublishedArticleListWidget extends StatelessWidget {
  final List<PublishedArticle> articles;
  final Axis axis;
  final Function(PublishedArticle article) onArticleClicked;
  final Function(PublishedArticle article) onLikeClicked;
  final Function(PublishedArticle article) onShareClicked;
  final Function(PublishedArticle article) onBookmarkClicked;

  // Private constructor
  const PublishedArticleListWidget._({
    super.key,
    required this.articles,
    required this.axis,
    required this.onArticleClicked,
    required this.onLikeClicked,
    required this.onShareClicked,
    required this.onBookmarkClicked,
  });

  // ✅ Named constructor - Horizontal
  const PublishedArticleListWidget.horizontal({
    Key? key,
    required List<PublishedArticle> articles,
    required Function(PublishedArticle article) onClicked,
    required Function(PublishedArticle article) onLikeClicked,
    required Function(PublishedArticle article) onShareClicked,
    required Function(PublishedArticle article) onBookmarkClicked,
  }) : this._(
          key: key,
          articles: articles,
          axis: Axis.horizontal,
          onArticleClicked: onClicked,
          onLikeClicked: onLikeClicked,
          onShareClicked: onShareClicked,
          onBookmarkClicked: onBookmarkClicked,
        );

  // ✅ Named constructor - Vertical
  const PublishedArticleListWidget.vertical({
    Key? key,
    required List<PublishedArticle> articles,
    required Function(PublishedArticle article) onClicked,
    required Function(PublishedArticle article) onLikeClicked,
    required Function(PublishedArticle article) onShareClicked,
    required Function(PublishedArticle article) onBookmarkClicked,
  }) : this._(
          key: key,
          articles: articles,
          axis: Axis.vertical,
          onArticleClicked: onClicked,
          onLikeClicked: onLikeClicked,
          onShareClicked: onShareClicked,
          onBookmarkClicked: onBookmarkClicked,
        );

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.horizontal) {
      return _buildHorizontalList();
    } else {
      return _buildVerticalList();
    }
  }

  Widget _buildHorizontalList() {
    return SizedBox(
      height: 185,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: axis,
        itemCount: articles.length,
        padding: EdgeInsets.only(left: 12, right: 12),
        itemBuilder: (context, index) {
          return PublishedArticleWidget.horizontal(
            article: articles[index],
            onClicked: onArticleClicked,
            onLikeClicked: onLikeClicked,
            onShareClicked: onShareClicked,
            onBookmarkClicked: onBookmarkClicked,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 8);
        },
      ),
    );
  }

  Widget _buildVerticalList() {
    return ResponsiveBuilder(
      mobile: (context) => ListView.separated(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: axis,
        shrinkWrap: true,
        itemCount: articles.length,
        padding: EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 180),
        itemBuilder: (context, index) {
          return PublishedArticleWidget.vertical(
            article: articles[index],
            onClicked: onArticleClicked,
            onLikeClicked: onLikeClicked,
            onShareClicked: onShareClicked,
            onBookmarkClicked: onBookmarkClicked,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 8);
        },
      ),
      tablet: (context)=> GridView.builder(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: axis,
        shrinkWrap: true,
        itemCount: articles.length,
        padding: EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 180),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          mainAxisExtent: 210
        ),
        itemBuilder: (context, index) {
          return PublishedArticleWidget.vertical(
            article: articles[index],
            onClicked: onArticleClicked,
            onLikeClicked: onLikeClicked,
            onShareClicked: onShareClicked,
            onBookmarkClicked: onBookmarkClicked,
          );
        },
      ),
    );
  }
}
