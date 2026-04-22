part of 'published_article_list_cubit.dart';

@freezed
class PublishedArticleListState with _$PublishedArticleListState {
  const PublishedArticleListState._();

  const factory PublishedArticleListState({
//
    @Default("") String title,
    PublishedArticleType? launchType,
//
    @Default([]) List<PublishedArticle> publishedArticles,
    @Default(LoadingState.loading) LoadingState publishedArticlesState,
//
  }) = _PublishedArticleListState;

  bool get isHotArticle => launchType == PublishedArticleType.hot;

  bool get isAvailableArticle => launchType == PublishedArticleType.available;
}

@freezed
class PublishedArticleListEvent with _$PublishedArticleListEvent {
  const factory PublishedArticleListEvent(type) = _PublishedArticleListEvent;
}
