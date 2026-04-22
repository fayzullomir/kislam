import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/domain/models/article/published_article.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_icon_button.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:koreaislam/presentation/widgets/image/network_rounded_image_widget.dart';

class PublishedArticleWidget extends StatelessWidget {
  final PublishedArticle article;
  final Axis axis;
  final Function(PublishedArticle article) onClicked;
  final Function(PublishedArticle article) onLikeClicked;
  final Function(PublishedArticle article) onShareClicked;
  final Function(PublishedArticle article) onBookmarkClicked;

  // Private constructor
  const PublishedArticleWidget._({
    super.key,
    required this.article,
    required this.axis,
    required this.onClicked,
    required this.onLikeClicked,
    required this.onShareClicked,
    required this.onBookmarkClicked,
  });

  // ✅ Named constructor - Vertical
  const PublishedArticleWidget.vertical({
    Key? key,
    required PublishedArticle article,
    required Function(PublishedArticle article) onClicked,
    required Function(PublishedArticle article) onLikeClicked,
    required Function(PublishedArticle article) onShareClicked,
    required Function(PublishedArticle article) onBookmarkClicked,
  }) : this._(
          key: key,
          article: article,
          axis: Axis.vertical,
          onClicked: onClicked,
          onLikeClicked: onLikeClicked,
          onShareClicked: onShareClicked,
          onBookmarkClicked: onBookmarkClicked,
        );

  // ✅ Named constructor - Horizontal
  const PublishedArticleWidget.horizontal({
    Key? key,
    required PublishedArticle article,
    required Function(PublishedArticle article) onClicked,
    required Function(PublishedArticle article) onLikeClicked,
    required Function(PublishedArticle article) onShareClicked,
    required Function(PublishedArticle article) onBookmarkClicked,
  }) : this._(
          key: key,
          article: article,
          axis: Axis.horizontal,
          onClicked: onClicked,
          onLikeClicked: onLikeClicked,
          onShareClicked: onShareClicked,
          onBookmarkClicked: onBookmarkClicked,
        );

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.horizontal) {
      return SizedBox(
        width: 260,
        child: PublishedArticleHorizontalWidget(
          article: article,
          axis: axis,
          onClicked: onClicked,
          onLikeClicked: onLikeClicked,
          onShareClicked: onShareClicked,
          onBookmarkClicked: onBookmarkClicked,
        ),
      );
    } else {
      return PublishedArticleVerticalWidget(
        article: article,
        axis: axis,
        onClicked: onClicked,
        onLikeClicked: onLikeClicked,
        onShareClicked: onShareClicked,
        onBookmarkClicked: onBookmarkClicked,
      );
    }
  }
}

class PublishedArticleHorizontalWidget extends StatelessWidget {
  final PublishedArticle article;
  final Axis axis;
  final Function(PublishedArticle article) onClicked;
  final Function(PublishedArticle article) onLikeClicked;
  final Function(PublishedArticle article) onShareClicked;
  final Function(PublishedArticle article) onBookmarkClicked;

  const PublishedArticleHorizontalWidget({
    super.key,
    required this.article,
    required this.axis,
    required this.onClicked,
    required this.onLikeClicked,
    required this.onShareClicked,
    required this.onBookmarkClicked,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      child: InkWell(
        onTap: () => onClicked(article),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: EdgeInsets.only(left: 12, top: 12, right: 12),
          child: Column(
            children: [
              _buildArticleImage(),
              SizedBox(height: 4),
              _buildActions(context),
              SizedBox(height: 0),
              _buildNameAndCategory(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleImage() {
    return NetworkRoundedImageWidget(
      imageUrl: article.mainPhoto,
      height: 80,
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        MaterialIconButton(
          size: 36,
          icon: (article.isLiked
                  ? Assets.images.component.likeFilled
                  : Assets.images.component.likeUnfilled)
              .svg(color: context.iconPrimary),
          onPressed: () => onLikeClicked(article),
        ),
        MaterialIconButton(
          size: 36,
          icon: Assets.images.component.share.svg(
            color: context.iconPrimary,
          ),
          onPressed: () => onShareClicked(article),
        ),
        Spacer(),
        MaterialIconButton(
          size: 36,
          icon: (article.isBookmarked
                  ? Assets.images.component.bookmarkFilled
                  : Assets.images.component.bookmarkUnfilled)
              .svg(color: context.iconPrimary),
          onPressed: () => onBookmarkClicked(article),
        ),
      ],
    );
  }

  Widget _buildNameAndCategory(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        article.title.s(14).w(500).copyWith(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        SizedBox(height: 5),
        Row(
          children: [
            // article.categoryName.s(14).w(500).c(context.textSecondary).copyWith(
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            // Spacer(),
            article.createdAt.s(14).w(500).c(context.textSecondary).copyWith(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          ],
        ),
        SizedBox(height: 12),
      ],
    );
  }
}

class PublishedArticleVerticalWidget extends StatelessWidget {
  final PublishedArticle article;
  final Axis axis;
  final Function(PublishedArticle article) onClicked;
  final Function(PublishedArticle article) onLikeClicked;
  final Function(PublishedArticle article) onShareClicked;
  final Function(PublishedArticle article) onBookmarkClicked;

  const PublishedArticleVerticalWidget({
    super.key,
    required this.article,
    required this.axis,
    required this.onClicked,
    required this.onLikeClicked,
    required this.onShareClicked,
    required this.onBookmarkClicked,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      child: InkWell(
        onTap: () => onClicked(article),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: EdgeInsets.only(left: 12, top: 12, right: 12),
          child: Column(
            children: [
              _buildArticleImage(),
              SizedBox(height: 4),
              _buildActions(context),
              SizedBox(height: 6),
              _buildNameAndCategory(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleImage() {
    return NetworkRoundedImageWidget(
      imageUrl: article.mainPhoto,
      height: 100,
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        MaterialIconButton(
          size: 36,
          icon: (article.isLiked
                  ? Assets.images.component.likeFilled
                  : Assets.images.component.likeUnfilled)
              .svg(color: context.iconPrimary),
          onPressed: () => onLikeClicked(article),
        ),
        MaterialIconButton(
          size: 36,
          icon: Assets.images.component.share.svg(
            color: context.iconPrimary,
          ),
          onPressed: () => onShareClicked(article),
        ),
        Spacer(),
        MaterialIconButton(
          size: 36,
          icon: (article.isBookmarked
                  ? Assets.images.component.bookmarkFilled
                  : Assets.images.component.bookmarkUnfilled)
              .svg(color: context.iconPrimary),
          onPressed: () => onBookmarkClicked(article),
        ),
      ],
    );
  }

  Widget _buildNameAndCategory(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        article.title.s(14).w(500).copyWith(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        SizedBox(height: 4),
        Row(
          children: [
            // article.categoryName.s(14).w(500).c(context.textSecondary).copyWith(
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            // Spacer(),
            article.createdAt.s(14).w(500).c(context.textSecondary).copyWith(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          ],
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
