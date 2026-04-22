// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'agency_article_response.freezed.dart';
part 'agency_article_response.g.dart';

@freezed
class AgencyRootArticleResponse with _$AgencyRootArticleResponse {
  const factory AgencyRootArticleResponse({
    @JsonKey(name: 'items')  List<AgencyArticleResponse>? items,
    @JsonKey(name: 'total')  int? total,
    @JsonKey(name: 'page')  int? page,
    @JsonKey(name: 'size') int? size,
    @JsonKey(name: 'pages')  int? pages,
  }) = _AgencyRootArticleResponse;

  factory AgencyRootArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$AgencyRootArticleResponseFromJson(json);
}

@freezed
class AgencyArticleResponse with _$AgencyArticleResponse {
  const factory AgencyArticleResponse({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'client_id') required int clientId,
    @JsonKey(name: 'operator_id') required int operatorId,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'photos') List<String>? photos,
    @JsonKey(name: 'like_count') int? likeCount,
    @JsonKey(name: 'view_count') int? viewCount,
    @JsonKey(name: 'shared_count') int? sharedCount,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _AgencyArticleResponse;

  factory AgencyArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$AgencyArticleResponseFromJson(json);
}