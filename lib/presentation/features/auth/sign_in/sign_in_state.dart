part of 'sign_in_cubit.dart';

@freezed
class SignInState with _$SignInState {
  const SignInState._();

  const factory SignInState({
    //
    @Default(SignInLaunchType.launchFromOnboarding) SignInLaunchType launchType,
    //
    @Default("") String phoneNumber,
    @Default("") String password,
    //
    @Default(false) bool isPhoneAlreadyRegistered,
    //
    @Default(false) bool isRequestSending,
    //
  }) = _SignInState;

  bool get isCanBack =>
      launchType == SignInLaunchType.launchFromProfile ||
      launchType == SignInLaunchType.launchFromAction;
}

@freezed
class SignInEvent with _$SignInEvent {
  const factory SignInEvent(SignInEventType type) = _SignInEvent;
}

sealed class SignInEventType {}

class OpenHomePage extends SignInEventType {
  final UserRole userRole;

  OpenHomePage({
    required this.userRole,
  });
}

class OpenOtpVerificationPage extends SignInEventType {
  final String phoneNumber;
  final String otpToken;
  final String userType;

  OpenOtpVerificationPage({
    required this.phoneNumber,
    required this.otpToken,
    required this.userType,
  });
}

class OpenResetPasswordPage extends SignInEventType {}
