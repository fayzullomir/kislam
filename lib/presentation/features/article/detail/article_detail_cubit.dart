import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/data/repositories/article/article_repository.dart';
import 'package:koreaislam/domain/models/article/published_article.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';
import 'package:koreaislam/presentation/support/extensions/extension_message_exts.dart';

part 'article_detail_cubit.freezed.dart';
part 'article_detail_state.dart';

@injectable
class ArticleDetailCubit
    extends BaseCubit<ArticleDetailState, ArticleDetailEvent> {
  final ArticleRepository _articleRepository;

  ArticleDetailCubit(this._articleRepository) : super(ArticleDetailState());

  void setInitialParams(int articleId, PublishedArticle? article) {
    updateState((state) => state.copyWith(
          articleId: articleId,
          article: article,
          isPrepared: article != null,
          isPreparingInProcess: false,
        ));

    fetchArticle();
  }

  fetchArticle() {
    _articleRepository
        .fetchArticleDetail(articleId: states.articleId)
        .initFuture()
        .onStart(() {
          updateState((s) => s.copyWith(isPreparingInProcess: true));
        })
        .onSuccess((data) {
          updateState((state) => state.copyWith(
                article: data,
                isPrepared: true,
                isPreparingInProcess: false,
              ));
        })
        .onError((error) {
          updateState((s) => s.copyWith(
                isPrepared: false,
                isPreparingInProcess: false,
              ));
          stateMessageManager.showErrorBottomSheet(error.localizedMessage);
        })
        .onFinished(() {})
        .executeFuture();
  }

  void setVisibleImageIndex(int index) {
    updateState((state) => state.copyWith(visibleImageIndex: index));
  }
}
