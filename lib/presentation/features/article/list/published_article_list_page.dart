import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/article/list/published_article_type.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/app_bar/default_app_bar.dart';
import 'package:koreaislam/presentation/widgets/article/published_article_list_shimmer.dart';
import 'package:koreaislam/presentation/widgets/article/published_article_list_widget.dart';
import 'package:koreaislam/presentation/widgets/scaffold/scrolling_scaffold.dart';
import 'package:koreaislam/presentation/widgets/state/default_empty_widget.dart';
import 'package:koreaislam/presentation/widgets/state/default_error_widget.dart';
import 'package:koreaislam/presentation/widgets/state/loader_state_widget.dart';

import 'published_article_list_cubit.dart';

@RoutePage()
class PublishedArticleListPage extends BasePage<PublishedArticleListCubit,
    PublishedArticleListState, PublishedArticleListEvent> {
  final String title;
  final PublishedArticleType type;

  PublishedArticleListPage({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  void onWidgetCreated(BuildContext context) {
    cubit(context).setInitialData(title, type);
  }

  @override
  Widget onWidgetBuild(BuildContext context, PublishedArticleListState state) {
    return ScrollingScaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, state),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return DefaultAppBar(
      title: title,
      backgroundColor: context.appBarColor,
      onBackPressed: () => context.router.popForced(),
    );
  }

  Widget _buildBody(BuildContext context, PublishedArticleListState state) {
    return RefreshIndicator(
      displacement: 80,
      strokeWidth: 3,
      color: StaticColors.colorAccent,
      onRefresh: () async {
        cubit(context).reloadData();
      },
      child: LoaderStateWidget(
        loadingState: state.publishedArticlesState,
        loadingBody: PublishedArticleListShimmer.vertical(),
        successBody: PublishedArticleListWidget.vertical(
          articles: state.publishedArticles,
          onClicked: (a) {
            context.router.push(ArticleDetailRoute(
              articleId: a.articleId,
              article: a,
            ));
          },
          onLikeClicked: (a) => cubit(context).onPackageLiked(a),
          onShareClicked: (a) {
            Share.share(
              '${a.title}\n${a.desc}',
              subject: a.title,
            );
          },
          onBookmarkClicked: (a) => cubit(context).onPackageBookmarked(a),
        ),
        emptyBody: DefaultEmptyWidget(
          isFullScreen: true,
          message: Strings.commonEmptyMessage,
          icon: Assets.images.publishedArticleListPageGroupEmpty
              .svg(width: 180, height: 170),
          onReloadClicked: () => cubit(context).fetchArticles(),
        ),
        errorBody: DefaultErrorWidget(
          isFullScreen: true,
          onRetryClicked: () => cubit(context).fetchArticles(),
        ),
      ),
    );
  }
}
