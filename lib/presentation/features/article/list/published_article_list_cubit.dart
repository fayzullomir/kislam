import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/enum/enums.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/data/repositories/article/article_repository.dart';
import 'package:koreaislam/domain/models/article/published_article.dart';
import 'package:koreaislam/presentation/features/article/list/published_article_type.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'published_article_list_cubit.freezed.dart';
part 'published_article_list_state.dart';

@Injectable()
class PublishedArticleListCubit
    extends BaseCubit<PublishedArticleListState, PublishedArticleListEvent> {
  final ArticleRepository _articleRepository;

  PublishedArticleListCubit(
    this._articleRepository,
  ) : super(PublishedArticleListState());

  void setInitialData(String title, PublishedArticleType launchType) {
    updateState((state) => state.copyWith(
          title: title,
          launchType: launchType,
        ));

    loadData();
  }

  void loadData() {
    fetchArticles();
  }

  void reloadData() {
    fetchArticles();
  }

  void fetchArticles() {
    _articleRepository
        .fetchArticles(page: 1, size: 10)
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(
                publishedArticlesState: LoadingState.loading,
              ));
        })
        .onSuccess((articles) {
          updateState((state) => state.copyWith(
                publishedArticles: articles,
                publishedArticlesState: articles.isEmpty
                    ? LoadingState.empty
                    : LoadingState.success,
              ));
        })
        .onError((error) {
          updateState((state) => state.copyWith(
                publishedArticlesState: LoadingState.error,
              ));
        })
        .onFinished(() {})
        .executeFuture();
  }

  void onPackageLiked(PublishedArticle article) {}

  void onPackageBookmarked(PublishedArticle article) {}
}
