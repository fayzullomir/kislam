import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/data/datasource/network/constants/constants.dart';
import 'package:koreaislam/presentation/features/auth/sign_in/sign_in_launch_type.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/router/auto_router_extensions.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/mask_formatters.dart';
import 'package:koreaislam/presentation/widgets/divider/custom_divider.dart';
import 'package:koreaislam/presentation/widgets/logo/AppLogo.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';
import 'package:koreaislam/presentation/widgets/material/material_filled_text_field.dart';
import 'package:koreaislam/presentation/widgets/material/material_outlined_button.dart';
import 'package:koreaislam/presentation/widgets/responsive/responsive_container.dart';
import 'package:koreaislam/utils/extensions/launcher_extensions.dart';
import 'package:koreaislam/utils/validator/not_empty_validator.dart';
import 'package:koreaislam/utils/validator/phone_number_validator.dart';

import 'sign_in_cubit.dart';

@RoutePage()
class SignInPage extends BasePage<SignInCubit, SignInState, SignInEvent> {
  SignInLaunchType launchType;

  SignInPage({
    super.key,
    required this.launchType,
  });

  @override
  void onWidgetCreated(BuildContext context) {
    cubit(context).setInitialData(launchType);
  }

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void onEventEmitted(BuildContext context, SignInEvent event) {
    switch (event.type) {
      case OpenHomePage():
        var actualEvent = event.type as OpenHomePage;
        context.router.replaceAll([actualEvent.userRole.homePage]);
        break;
      case OpenResetPasswordPage():
        break;
      case OpenOtpVerificationPage():
        var actualEvent = event.type as OpenOtpVerificationPage;
        context.router.push(
          OtpVerificationRoute(
            phoneNumber: actualEvent.phoneNumber,
            otpToken: actualEvent.otpToken,
            userType: actualEvent.userType,
          ),
        );
        break;
    }
  }

  @override
  Widget onWidgetBuild(BuildContext context, SignInState state) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.pageBackgroundColor,
      body: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 7),
              _buildFieldContainer(context, state),
              Spacer(flex: 9),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldContainer(BuildContext context, SignInState state) {
    return ResponsiveContainer(
      tabletMaxWidth: 500,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(32, 36, 32, 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: context.backgroundGreyColor.withOpacity(0.7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppLogo(size: 64),
            SizedBox(height: 16),
            Strings.signInTitleAuthorize.s(20).w(500).c(context.textPrimary),
            SizedBox(height: 20),
            MaterialFilledTextField(
              hint: Strings.commonPhoneNumber,
              autofillHints: const [
                AutofillHints.username,
                AutofillHints.telephoneNumber,
                AutofillHints.telephoneNumberNational
              ],
              enableSuggestions: true,
              inputFormatters: [
                uzbekPhoneMaskFormatter,
                LengthLimitingTextInputFormatter(17)
              ],
              rightIcon: Assets.images.signInPageInputLogin.svg(),
              maxLines: 1,
              keyboardType: TextInputType.phone,
              textInputAction: state.isPhoneAlreadyRegistered
                  ? TextInputAction.next
                  : TextInputAction.done,
              controller: _phoneController,
              prefixText: '+998 ',
              textDirection: TextDirection.ltr,
              validator: (v) => PhoneNumberValidator.validate(v),
              onChanged: (v) => cubit(context).setPhoneNumber(v),
            ),
            if (state.isPhoneAlreadyRegistered) ...[
              SizedBox(height: 12),
              MaterialFilledTextField(
                hint: Strings.commonPassword,
                autofillHints: const [AutofillHints.password],
                enableSuggestions: true,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                obscureText: true,
                controller: _passwordController,
                validator: (v) => NotEmptyValidator.validate(v),
                // for support mock/demo accounts not use PasswordValidator
                onChanged: (v) => cubit(context).setPassword(v),
              ),
            ],
            SizedBox(height: 16),
            ..._buildPrivacyPolicyText(context, state),
            SizedBox(height: 16),
            MaterialElevatedButton(
              text: state.isPhoneAlreadyRegistered
                  ? Strings.signInTitleAuthorize
                  : Strings.commonContinue,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (state.isPhoneAlreadyRegistered) {
                    // FocusScope.of(context).unfocus();
                    TextInput.finishAutofillContext(shouldSave: true);
                  }
                  cubit(context).checkOrSignIn();
                }
              },
              loading: state.isRequestSending,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomDivider(thickness: 1),
                ),
                SizedBox(width: 8),
                Strings.signInOr.s(12).w(400).c(context.textPrimary),
                SizedBox(width: 8),
                Expanded(
                  child: CustomDivider(thickness: 1),
                ),
              ],
            ),
            SizedBox(height: 20),
            MaterialOutlinedButton(
              text: Strings.signInContinueAsGuest,
              onPressed: () => context.router.replaceAll([MainRoute()]),
              loading: state.isRequestSending,
            ),
            SizedBox(height: 16),
            _buildAppVersionBlock(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPrivacyPolicyText(
    BuildContext context,
    SignInState state,
  ) {
    return [
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: Strings.authConsentIntro,
              style: TextStyle(
                color: context.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => openCustomTab(Constants.privacyPolicyUrl),
              text: Strings.authConsentTerms,
              style: TextStyle(
                color: context.primaryLight,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: Strings.authConsentAnd,
              style: TextStyle(
                color: context.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => openCustomTab(Constants.termsAndConditionsUrl),
              text: Strings.authConsentPrivacy,
              style: TextStyle(
                color: context.primaryLight,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: Strings.authConsentOutro,
              style: TextStyle(
                color: context.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  Widget _buildAppVersionBlock() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        return Column(
          children: [
            "Korea Islam © 2025".w(400).s(12),
            SizedBox(height: 6),
            "v ${snapshot.data?.version} (${snapshot.data?.buildNumber})"
                .w(400)
                .s(12)
                .c(context.textSecondary),
          ],
        );
      },
    );
  }

  /// Bottom sheet methods
}
