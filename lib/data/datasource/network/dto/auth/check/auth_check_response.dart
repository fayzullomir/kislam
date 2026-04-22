// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_check_response.freezed.dart';
part 'auth_check_response.g.dart';

@freezed
class AuthCheckResponse with _$AuthCheckResponse {
  const factory AuthCheckResponse({
    @JsonKey(name: 'is_registered') required bool isRegistered,
    @JsonKey(name: 'user_type') required String userType,
    @JsonKey(name: 'token') required String otpToken,
    @JsonKey(name: 'message') String? message,
  }) = _AuthCheckResponse;

  factory AuthCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthCheckResponseFromJson(json);
}
