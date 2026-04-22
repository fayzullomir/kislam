// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'terminate_session_response.freezed.dart';
part 'terminate_session_response.g.dart';

@freezed
class TerminateSessionResponse with _$TerminateSessionResponse {
  const TerminateSessionResponse._();

  const factory TerminateSessionResponse({
    @JsonKey(name: 'success') required bool isTerminated,
    @JsonKey(name: 'message') String? message,
  }) = _TerminateSessionResponse;

  bool get hasMessage => message != null && message!.isNotEmpty;

  factory TerminateSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$TerminateSessionResponseFromJson(json);
}
