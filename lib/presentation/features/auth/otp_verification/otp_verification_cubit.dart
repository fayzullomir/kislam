import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/repositories/auth/sign_up_repository.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';
import 'package:koreaislam/presentation/support/extensions/extension_message_exts.dart';

part 'otp_verification_cubit.freezed.dart';
part 'otp_verification_state.dart';

@injectable
class OtpVerificationCubit
    extends BaseCubit<OtpVerificationState, OtpVerificationEvent> {
  final SignUpRepository _signUpRepository;
  final SmartAuth _smartAuth = SmartAuth();

  OtpVerificationCubit(
    this._signUpRepository,
  ) : super(const OtpVerificationState());

  void setInitialData(String phoneNumber, String otpToken, String userType) {
    updateState((state) => state.copyWith(
          phoneNumber: phoneNumber,
          otpToken: otpToken,
          userType: userType,
        ));

    requestOtpCode();
  }

  void setEnteredOtpCode(String otpCode) {
    updateState((state) => state.copyWith(otpCode: otpCode));
  }

  Future<void> startListening() async {
    AppLog.e("startListening: method called");
    try {
      emitEvent(OtpVerificationEvent(OtpListening()));

      AppLog.e("startListening: SMS listening is active");
      final result = await _smartAuth.getSmsCode();

      if (result.codeFound) {
        final code = result.code!;
        AppLog.e("codeUpdated: code value = $code");
        emitEvent(OtpVerificationEvent(OtpCodeReceived(code)));
      } else {
        AppLog.e("codeUpdated: Code is null or empty");
      }
    } catch (e, stackTrace) {
      AppLog.e("startListening: Error: $e");
      AppLog.e("startListening: Stack trace: $stackTrace");
      emitEvent(OtpVerificationEvent(OtpError()));
    }
  }

  Future<void> stopListening() async {
    try {
      AppLog.e("stopListening: Stopping SMS listener");
      await _smartAuth.removeSmsListener();
      AppLog.e("stopListening: SMS listener stopped");
    } catch (e) {
      AppLog.e("stopListening: Error stopping listener: $e");
    }
  }

  void requestOtpCode() {
    _signUpRepository
        .requestOtpCode(
          phoneNumber: states.phoneNumber,
          otpToken: states.otpToken,
          userType: states.userType,
        )
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(isRequestingOtp: true));
        })
        .onSuccess((data) {
          startListening();

          updateState((state) => state.copyWith(isRequestingOtp: false));
          if (data.isOtpCodeSent) {
            startTimer();
          } else {
            stopTimer();
            stateMessageManager.showErrorBottomSheet(data.message ??
                Strings.otpVerificationRequestCodeFailedMessage);
          }
        })
        .onError((error) {
          updateState((state) => state.copyWith(isRequestingOtp: false));
          stateMessageManager.showErrorBottomSheet(error.localizedMessage);
        })
        .onFinished(() {})
        .executeFuture();
  }

  void startTimer() {
    if (states.isTimerRunning) {
      return;
    }

    updateState((state) => state.copyWith(timer: 60));

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      updateState((state) => state.copyWith(timer: states.timer - 1));
      if (states.timer <= 0) {
        return false;
      }
      return true;
    });
  }

  void stopTimer() {
    updateState((state) => state.copyWith(timer: 0));
  }

  void verifyOtpCode() {
    _signUpRepository
        .verifyOtpCode(
          phoneNumber: states.phoneNumber,
          otpCode: states.otpCode,
          otpToken: states.otpToken,
          userType: states.userType,
        )
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(isVerifyingOtp: true));
        })
        .onSuccess((data) {
          stopListening();

          updateState((state) => state.copyWith(isVerifyingOtp: false));
          if (data.isVerified) {
            stopTimer();

            emitEvent(OtpVerificationEvent(OpenSignUpPage(
              states.phoneNumber,
              states.userType,
            )));
          } else {
            stateMessageManager.showErrorBottomSheet(data.message ??
                "Kodni tasdiqlashda xatolik yuz berdi. Iltimos, qayta urinib ko'ring.");
          }
        })
        .onError((error) {
          updateState((state) => state.copyWith(isVerifyingOtp: false));
          stateMessageManager.showErrorBottomSheet(error.localizedMessage);
        })
        .onFinished(() {})
        .executeFuture();
  }
}
