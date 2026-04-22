import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/preference/profile_preferences.dart';
import 'package:koreaislam/data/repositories/auth/sign_in_repository.dart';
import 'package:koreaislam/data/repositories/profile/profile_repository.dart';
import 'package:koreaislam/domain/models/user/user_role.dart';
import 'package:koreaislam/presentation/features/auth/sign_in/sign_in_launch_type.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';
import 'package:koreaislam/presentation/support/extensions/extension_message_exts.dart';

part 'sign_in_cubit.freezed.dart';
part 'sign_in_state.dart';

@injectable
class SignInCubit extends BaseCubit<SignInState, SignInEvent> {
  final SignInRepository _signInRepository;
  final ProfilePreferences _profilePreferences;
  final ProfileRepository _profileRepository;

  SignInCubit(
    this._signInRepository,
    this._profilePreferences,
    this._profileRepository,
  ) : super(const SignInState());

  UserRole get userRole => _profilePreferences.userRole;

  void setInitialData(SignInLaunchType launchType) {
    updateState((state) => state.copyWith(launchType: launchType));
  }

  void setPhoneNumber(String phoneNumber) {
    updateState((state) => state.copyWith(
          phoneNumber: "998$phoneNumber".replaceAll(' ', ''),
          isPhoneAlreadyRegistered: false,
        ));
  }

  void setPassword(String password) {
    updateState((state) => state.copyWith(password: password));
  }

  void checkOrSignIn() {
    if (states.isPhoneAlreadyRegistered) {
      signIn();
    } else {
      checkUserName();
    }
  }

  Future<void> checkUserName() async {
    _signInRepository
        .checkUserName(states.phoneNumber)
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(isRequestSending: true));
        })
        .onSuccess((data) {
          updateState((state) => state.copyWith(
                isPhoneAlreadyRegistered: data.isRegistered,
                isRequestSending: false,
              ));
          if (!data.isRegistered) {
            emitEvent(SignInEvent(OpenOtpVerificationPage(
              phoneNumber: states.phoneNumber,
              otpToken: data.otpToken,
              userType: data.userType,
            )));
          }
        })
        .onError((error) {
          updateState((state) => state.copyWith(isRequestSending: false));
          stateMessageManager.showErrorBottomSheet(error.localizedMessage);
        })
        .onFinished(() {})
        .executeFuture();
  }

  void signIn() {
    _signInRepository
        .signIn(states.phoneNumber, states.password)
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(isRequestSending: true));
        })
        .onSuccess((data) {
          AppLog.e("signIn success");
          _fetchProfile();
        })
        .onError((error) {
          AppLog.e("signIn error", error: error);
          updateState((state) => state.copyWith(isRequestSending: false));
          stateMessageManager.showErrorBottomSheet(error.localizedMessage);
        })
        .onFinished(() {})
        .executeFuture();
  }

  void _fetchProfile() {
    _profileRepository
        .fetchProfile()
        .initFuture()
        .onStart(() {})
        .onSuccess((data) {
          updateState((state) => state.copyWith(isRequestSending: false));
          emitEvent(SignInEvent(OpenHomePage(userRole: userRole)));
        })
        .onError((error) {
          updateState((state) => state.copyWith(isRequestSending: false));
          emitEvent(SignInEvent(OpenHomePage(userRole: userRole)));
        })
        .onFinished(() {})
        .executeFuture();
  }

  Future<void> forgetPassword() async {}
}
