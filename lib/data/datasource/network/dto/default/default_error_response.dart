// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'default_error_response.freezed.dart';
part 'default_error_response.g.dart';

@freezed
class DefaultErrorResponse with _$DefaultErrorResponse {
  const DefaultErrorResponse._();

  const factory DefaultErrorResponse({
    @DetailConverter()
    @JsonKey(name: "detail")
    DefaultErrorDetailResponse? detail,
  }) = _DefaultErrorResponse;

  bool get hasDetailMessage =>
      detail != null && detail!.message != null && detail!.message!.isNotEmpty;

  String? get detailMessage => detail?.message;

  String? get errorCode => detail?.code;

  factory DefaultErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$DefaultErrorResponseFromJson(json);

  static DefaultErrorResponse? safeParse(Object? source) {
    if (source == null) return null;
    if (source is DefaultErrorResponse) return source;

    if (source is Map<String, dynamic>) {
      if (source.isEmpty) return null;
      return DefaultErrorResponse.fromJson(source);
    }

    if (source is Map) {
      final normalized = <String, dynamic>{};
      source.forEach((key, value) {
        normalized[key.toString()] = value;
      });
      if (normalized.isEmpty) return null;
      return DefaultErrorResponse.fromJson(normalized);
    }

    final detail = const DetailConverter().fromJson(source);
    if (detail == null) return null;
    return DefaultErrorResponse(detail: detail);
  }
}

@freezed
class DefaultErrorDetailResponse with _$DefaultErrorDetailResponse {
  const factory DefaultErrorDetailResponse({
    @JsonKey(name: "code") String? code,
    @JsonKey(name: "message") String? message,
  }) = _DefaultErrorDetailResponse;

  factory DefaultErrorDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$DefaultErrorDetailResponseFromJson(json);
}

class DetailConverter
    implements JsonConverter<DefaultErrorDetailResponse?, Object?> {
  const DetailConverter();

  @override
  DefaultErrorDetailResponse? fromJson(Object? json) {
    if (json == null) return null;

    if (json is String) {
      return json.trim().isEmpty
          ? null
          : DefaultErrorDetailResponse(message: json);
    }

    if (json is Map<String, dynamic>) {
      if (json.isEmpty) return null;
      return DefaultErrorDetailResponse.fromJson(json);
    }

    if (json is Map) {
      final normalized = json.map(
            (key, value) => MapEntry(key.toString(), value),
      );
      if (normalized.isEmpty) return null;
      return DefaultErrorDetailResponse.fromJson(
        Map<String, dynamic>.from(normalized),
      );
    }

    if (json is List) {
      for (final entry in json) {
        final detail = fromJson(entry);
        if (detail != null) return detail;
      }
      return null;
    }

    return DefaultErrorDetailResponse(message: json.toString());
  }

  @override
  Object? toJson(DefaultErrorDetailResponse? object) {
    return object?.toJson();
  }
}