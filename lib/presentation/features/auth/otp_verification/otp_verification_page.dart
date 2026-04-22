import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/auth/otp_verification/otp_verification_cubit.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/colors/static_colors.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';
import 'package:koreaislam/presentation/widgets/material/material_outlined_button.dart';
import 'package:koreaislam/presentation/widgets/material/material_text_button.dart';
import 'package:koreaislam/presentation/widgets/material/material_otp_code_text_field.dart';
import 'package:koreaislam/presentation/widgets/logo/AppLogo.dart';
import 'package:koreaislam/presentation/widgets/responsive/responsive_container.dart';

@RoutePage()
class OtpVerificationPage extends BasePage<OtpVerificationCubit,
    OtpVerificationState, OtpVerificationEvent> {
  final String phoneNumber;
  final String otpToken;
  final String userType;

  OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.otpToken,
    required this.userType,
  });

  final TextEditingController _otpController = TextEditingController();

  @override
  void onWidgetCreated(BuildContext context) {
    cubit(context).setInitialData(phoneNumber, otpToken, userType);
  }

  @override
  void onEventEmitted(BuildContext context, OtpVerificationEvent event) {
    switch (event.type) {
      case OtpInitial():
        break;
      case OtpListening():
        break;
      case OtpCodeReceived():
        final code = (event.type as OtpCodeReceived).code;
        _otpController.text = code;
        cubit(context).setEnteredOtpCode(code);
        cubit(context).verifyOtpCode();
        break;
      case OtpError():
        break;
      case OpenSignUpPage():
        context.router.replace(SignUpRoute(
          phoneNumber: phoneNumber,
          userType: userType,
        ));
        break;
    }
  }

  @override
  Widget onWidgetBuild(BuildContext context, OtpVerificationState state) {
    return Scaffold(
      backgroundColor: context.pageBackgroundColor,
      body: ResponsiveContainer(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        tabletMaxWidth: 500,
        child: Container(
          padding: const EdgeInsets.fromLTRB(32, 36, 32, 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: context.backgroundGreyColor.withOpacity(0.7),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppLogo(size: 48),
              SizedBox(height: 12),
              Strings.otpVerificationTitle.s(18).w(700),
              SizedBox(height: 12),
              Strings.otpVerificationSentToPhoneNumber(
                      phoneNumber.formatted)
                  .s(14)
                  .w(500)
                  .c(context.textSecondary)
                  .copyWith(textAlign: TextAlign.center),
              SizedBox(height: 32),
              MaterialOtpCodeTextField(
                controller: _otpController,
                onChanged: (value) {
                  cubit(context).setEnteredOtpCode(value);
                },
              ),
              const SizedBox(height: 12),
              MaterialTextButton(
                text: state.isTimerRunning
                    ? "${Strings.otpVerificationSendAgain}  ${_formatSeconds(state.timer)}"
                    : Strings.otpVerificationSendAgain,
                textSize: 18,
                isEnabled: !state.isTimerRunning,
                textColor: state.isTimerRunning
                    ? context.textPrimary
                    : StaticColors.colorAccent,
                isLoading: state.isRequestingOtp,
                onPressed: () {
                  cubit(context).requestOtpCode();
                },
              ),
              const SizedBox(height: 32),
              MaterialElevatedButton(
                text: Strings.commonNext,
                onPressed: () {
                  cubit(context).verifyOtpCode();
                },
                loading: state.isVerifyingOtp,
              ),
              const SizedBox(height: 12),
              MaterialOutlinedButton(
                text: Strings.commonBack,
                onPressed: () {
                  context.router.popForced();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatSeconds(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }
}
