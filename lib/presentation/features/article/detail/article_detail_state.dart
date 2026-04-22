part of 'article_detail_cubit.dart';

@freezed
class ArticleDetailState with _$ArticleDetailState {
  const ArticleDetailState._();

  const factory ArticleDetailState({
    //
    @Default(false) bool isPrepared,
    @Default(false) bool isPreparingInProcess,
    //
    @Default(0) int articleId,
    PublishedArticle? article,
    //
    @Default(0) int visibleImageIndex,
  }) = _ArticleDetailState;

  PublishedArticle get item => article!;

  List<String> get images => article?.photos ?? [];

  int get imagesCount => images.length;
}

@freezed
class ArticleDetailEvent with _$ArticleDetailEvent {
  const factory ArticleDetailEvent(ArticleDetailEventType type) =
      _ArticleDetailEvent;
}

sealed class ArticleDetailEventType {}
