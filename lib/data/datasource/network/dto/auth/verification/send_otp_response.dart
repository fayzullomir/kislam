// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_otp_response.freezed.dart';
part 'send_otp_response.g.dart';

@freezed
class SendOtpResponse with _$SendOtpResponse {
  const factory SendOtpResponse({
    @JsonKey(name: 'is_sent') required bool isOtpCodeSent,
    @JsonKey(name: 'message') String? message,
  }) = _SendOtpResponse;

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseFromJson(json);
}
