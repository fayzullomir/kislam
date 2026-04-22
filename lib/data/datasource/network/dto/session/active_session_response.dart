// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_session_response.freezed.dart';
part 'active_session_response.g.dart';

@freezed
class ActiveSessionRootResponse with _$ActiveSessionRootResponse {
  const factory ActiveSessionRootResponse({
    @JsonKey(name: 'total') required int total,
    @JsonKey(name: 'page') required int page,
    @JsonKey(name: 'size') required int size,
    @JsonKey(name: 'items') required List<ActiveSessionResponse> sessions,
  }) = _ActiveSessionRootResponse;

  factory ActiveSessionRootResponse.fromJson(Map<String, dynamic> json) =>
      _$ActiveSessionRootResponseFromJson(json);
}

@freezed
class ActiveSessionResponse with _$ActiveSessionResponse {
  const factory ActiveSessionResponse({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'token') String? token,
    @JsonKey(name: 'unique_id') required String uniqueId,
    @JsonKey(name: 'app_version_code') int? appVersionCode,
    @JsonKey(name: 'app_version_name') String? appVersionName,
    @JsonKey(name: 'device_id') String? deviceId,
    @JsonKey(name: 'device_name') String? deviceName,
    @JsonKey(name: 'device_model') String? deviceModel,
    @JsonKey(name: 'app_source') String? appSource,
    @JsonKey(name: 'refresh_id') String? refreshId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ActiveSessionResponse;

  factory ActiveSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$ActiveSessionResponseFromJson(json);
}
