part of 'otp_verification_cubit.dart';

@freezed
class OtpVerificationState with _$OtpVerificationState {
  const OtpVerificationState._();

  const factory OtpVerificationState({
    //
    @Default('') String phoneNumber,
    @Default('') String otpToken,
    @Default('') String userType,
    //
    @Default('') String otpCode,
    //
    @Default(false) bool isRequestingOtp,
    //
    @Default(false) bool isVerifyingOtp,
    //
    @Default(0) int timer,
    //
  }) = _OtpVerificationState;

  bool get isTimerRunning => timer > 0;
}

@freezed
class OtpVerificationEvent with _$OtpVerificationEvent {
  const factory OtpVerificationEvent(OtpVerificationEventType type) =
      _OtpVerificationEvent;
}

sealed class OtpVerificationEventType {}

class OtpInitial extends OtpVerificationEventType {}

class OtpListening extends OtpVerificationEventType {}

class OtpCodeReceived extends OtpVerificationEventType {
  final String code;

  OtpCodeReceived(this.code);
}

class OtpError extends OtpVerificationEventType {}

class OpenSignUpPage extends OtpVerificationEventType {
  final String phoneNumber;
  final String userType;

  OpenSignUpPage(this.phoneNumber, this.userType);
}
