// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_response.freezed.dart';
part 'logout_response.g.dart';

@freezed
class LogoutResponse with _$LogoutResponse {
  const LogoutResponse._();

  const factory LogoutResponse({
    @JsonKey(name: 'success') required bool isTerminated,
    @JsonKey(name: 'message') String? message,
  }) = _LogoutResponse;

  bool get hasMessage => message != null && message!.isNotEmpty;

  factory LogoutResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseFromJson(json);
}
