import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:koreaislam/core/extensions/date_extensions.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/domain/models/article/published_article.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/app_bar/default_app_bar.dart';
import 'package:koreaislam/presentation/widgets/divider/custom_divider.dart';
import 'package:koreaislam/presentation/widgets/image/network_rounded_image_widget.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:koreaislam/presentation/widgets/scaffold/scrolling_scaffold.dart';
import 'package:koreaislam/presentation/widgets/state/default_error_widget.dart';
import 'package:koreaislam/presentation/widgets/state/default_loading_widget.dart';

import 'article_detail_cubit.dart';

@RoutePage()
class ArticleDetailPage extends BasePage<ArticleDetailCubit,
    ArticleDetailState, ArticleDetailEvent> {
  int articleId;
  PublishedArticle? article;

  ArticleDetailPage({
    super.key,
    required this.articleId,
    required this.article,
  });

  @override
  void onWidgetCreated(BuildContext context) {
    cubit(context).setInitialParams(articleId, article);
  }

  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget onWidgetBuild(BuildContext context, ArticleDetailState state) {
    return ScrollingScaffold(
      appBar: _buildAppBar(context, state),
      body: state.isPrepared
          ? _buildSuccessBody(context, state)
          : _buildPreparingBody(context, state),
    );
  }

  Widget _buildPreparingBody(
    BuildContext context,
    ArticleDetailState state,
  ) {
    return state.isPreparingInProcess
        ? DefaultLoadingWidget(isFullScreen: true)
        : DefaultErrorWidget(
            isFullScreen: true,
            onRetryClicked: () => cubit(context).fetchArticle(),
          );
  }

  Widget _buildSuccessBody(BuildContext context, ArticleDetailState state) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 20),
        _ArticleInfoBlock(state: state),
        SizedBox(height: 12),
        if (state.imagesCount > 0) ...[
          _ArticlePhotosBlock(
            state: state,
            controller: _controller,
            onImageTap: (index) {
              context.router.push(
                ImageViewerRoute(
                  images: state.images,
                  initialIndex: index,
                ),
              );
            },
            onPageChanged: (index) {
              cubit(context).setVisibleImageIndex(index);
            },
          ),
          SizedBox(height: 12),
        ],
        _ArticleDescBlock(state: state),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, ArticleDetailState state) {
    return DefaultAppBar(
      title: "",
      titleTextColor: context.textPrimary,
      backgroundColor: context.appBarColor,
      onBackPressed: () => context.router.pop(),
    );
  }
}

class _ArticleInfoBlock extends StatelessWidget {
  const _ArticleInfoBlock({required this.state});

  final ArticleDetailState state;

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      margin: const EdgeInsets.only(left: 16, right: 16),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          state.item.title.s(16).w(600),
          SizedBox(height: 12),
          CustomDivider(thickness: 1),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Strings.articleDetailCreatedAt.s(14).w(400),
              Spacer(),
              state.item.createdAt
                  .convertDateFormat(outputFormat: "dd.MM.yyyy")
                  .s(14)
                  .w(600),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArticlePhotosBlock extends StatelessWidget {
  const _ArticlePhotosBlock({
    required this.state,
    required this.controller,
    required this.onImageTap,
    required this.onPageChanged,
  });

  final ArticleDetailState state;
  final CarouselSliderController controller;
  final ValueChanged<int> onImageTap;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      margin: const EdgeInsets.only(left: 16, right: 16),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Strings.articleDetailImages.s(16).w(600),
          SizedBox(height: 12),
          CarouselSlider(
            carouselController: controller,
            options: CarouselOptions(
              autoPlay: false,
              height: 240,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                onPageChanged(index);
              },
            ),
            items: state.images.mapIndexed((index, image) {
              return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    onTap: () => onImageTap(index),
                    child: NetworkRoundedImageWidget(imageUrl: image),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 8),
          Center(
            child: AnimatedSmoothIndicator(
              activeIndex: state.visibleImageIndex,
              effect: ExpandingDotsEffect(
                dotWidth: 9,
                dotHeight: 3,
                spacing: 5,
                radius: 3,
                dotColor: StaticColors.colorAccent.withOpacity(0.5),
                activeDotColor: StaticColors.colorAccent,
              ),
              count: state.imagesCount,
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _ArticleDescBlock extends StatelessWidget {
  const _ArticleDescBlock({required this.state});

  final ArticleDetailState state;

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      margin: const EdgeInsets.only(left: 16, right: 16),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Strings.articleDetailInfo.s(16).w(600),
          SizedBox(height: 12),
          state.item.desc.s(14).w(400).c(context.textPrimary),
        ],
      ),
    );
  }
}
