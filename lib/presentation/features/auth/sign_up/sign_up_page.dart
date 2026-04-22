import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/presentation/features/gender/gender_selection_page.dart';
import 'package:koreaislam/presentation/features/region/country/country_selection_page.dart';
import 'package:koreaislam/presentation/features/region/district/district_selection_page.dart';
import 'package:koreaislam/presentation/features/region/region/region_selection_page.dart';
import 'package:koreaislam/presentation/router/app_router.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/mask_formatters.dart';
import 'package:koreaislam/presentation/widgets/app_bar/default_app_bar.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:koreaislam/presentation/widgets/material/material_filled_dropdown_field.dart';
import 'package:koreaislam/presentation/widgets/material/material_filled_text_field.dart';
import 'package:koreaislam/presentation/widgets/text/description_text_widget.dart';
import 'package:koreaislam/utils/extensions/resource_extensions.dart';
import 'package:koreaislam/utils/validator/date_validator.dart';
import 'package:koreaislam/utils/validator/not_empty_validator.dart';
import 'package:koreaislam/utils/validator/password_confirm_validator.dart';
import 'package:koreaislam/utils/validator/password_validator.dart';

import 'sign_up_cubit.dart';

@RoutePage()
class SignUpPage extends BasePage<SignUpCubit, SignUpState, SignUpEvent> {
  final String phoneNumber;
  final String userType;

  SignUpPage({
    super.key,
    required this.phoneNumber,
    required this.userType,
  });

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void onWidgetCreated(BuildContext context) {
    cubit(context).setInitialData(phoneNumber: phoneNumber, userType: userType);
  }

  @override
  void onEventEmitted(BuildContext context, SignUpEvent event) {
    switch (event.type) {
      case OpenHomePage():
        context.router.replaceAll([MainRoute()]);
        break;
    }
  }

  @override
  Widget onWidgetBuild(BuildContext context, SignUpState state) {
    return Scaffold(
      appBar: DefaultAppBar(
          title: Strings.signUpTitle,
          backgroundColor: context.appBarColor,
          onBackPressed: () {
            context.router.pop();
          }),
      backgroundColor: context.pageBackgroundColor,
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, SignUpState state) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            _SignUpPersonalInfoBlock(
              state: state,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              emailController: _emailController,
              onFirstNameChanged: (v) => cubit(context).setEnteredFirstName(v),
              onLastNameChanged: (v) => cubit(context).setEnteredLastName(v),
              onEmailChanged: (v) => cubit(context).setEnteredEmail(v),
              onGenderTap: () {
                showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => GenderSelectionPage(
                    initialGender: state.selectedGender,
                  ),
                );
              },
              onDateOfBirthTap: () {
                showDefaultDatePickerDialog(
                  context: context,
                  title: Strings.signUpBirthDateHint,
                  selectedDate: DateTime.tryParse(state.dateOfBirth),
                  recommendedDate: DateTime(1990, 9, 1),
                  onDateSelected: (date) {
                    cubit(context).setDateOfBirth(date);
                  },
                );
              },
            ),
            SizedBox(height: 12),
            _SignUpRegionBlock(
              state: state,
              onCountryTap: () {
                showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => CountrySelectionPage(
                    initialCountry: state.selectedCountry,
                  ),
                );
              },
              onRegionTap: () {
                if (state.selectedCountry == null) {
                  showErrorBottomSheet(
                    context,
                    Strings.signUpErrorCountryNotSelected,
                  );
                  return;
                }
                showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => RegionSelectionPage(
                    initialCountryId: state.selectedCountry!.id,
                    initialRegion: state.selectedRegion,
                  ),
                );
              },
              onDistrictTap: () {
                if (state.selectedRegion == null) {
                  showErrorBottomSheet(
                    context,
                    Strings.signUpErrorRegionNotSelected,
                  );
                  return;
                }
                showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => DistrictSelectionPage(
                    initialRegionId: state.selectedRegion!.id,
                    initialDistrict: state.selectedDistrict,
                  ),
                );
              },
            ),
            SizedBox(height: 12),
            _SignUpPasswordBlock(
              state: state,
              passwordController: _passwordController,
              passwordConfirmController: _passwordConfirmController,
              onPasswordChanged: (v) => cubit(context).setEnteredPassword(v),
              onPasswordConfirmChanged: (v) =>
                  cubit(context).setEnteredPasswordConfirm(v),
            ),
            SizedBox(height: 12),
            _SignUpActionBlock(
              state: state,
              onPrivacyPolicyTap: () => cubit(context).launchURLApp(),
              onSubmitTap: () {
                if (_formKey.currentState!.validate()) {
                  TextInput.finishAutofillContext(shouldSave: true);
                  cubit(context).signUp();
                }
              },
            ),
            SizedBox(height: 96),
          ],
        ),
      ),
    );
  }

}

class _SignUpPersonalInfoBlock extends StatelessWidget {
  const _SignUpPersonalInfoBlock({
    required this.state,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onEmailChanged,
    required this.onGenderTap,
    required this.onDateOfBirthTap,
  });

  final SignUpState state;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onGenderTap;
  final VoidCallback onDateOfBirthTap;

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      margin: EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Strings.signUpPersonalInfoBlock.s(16).w(600).c(context.textPrimary),
          SizedBox(height: 20),
          MaterialFilledTextField(
            inputType: TextInputType.name,
            keyboardType: TextInputType.name,
            maxLines: 1,
            hint: Strings.signUpFirstNameHint,
            textInputAction: TextInputAction.next,
            controller: firstNameController,
            inputFormatters: [DenyEmojiFormatter()],
            validator: (v) => NotEmptyValidator.validate(v),
            textCapitalization: TextCapitalization.words,
            onChanged: onFirstNameChanged,
          ),
          SizedBox(height: 12),
          MaterialFilledTextField(
            inputType: TextInputType.name,
            keyboardType: TextInputType.name,
            maxLines: 1,
            hint: Strings.signUpLastNameHint,
            textInputAction: TextInputAction.next,
            controller: lastNameController,
            inputFormatters: [DenyEmojiFormatter()],
            validator: (v) => NotEmptyValidator.validate(v),
            textCapitalization: TextCapitalization.words,
            onChanged: onLastNameChanged,
          ),
          SizedBox(height: 12),
          MaterialFilledDropdownField(
            value: state.selectedGender?.localizedName ?? "",
            hint: Strings.signUpGenderHint,
            validator: (v) => NotEmptyValidator.validate(v),
            onTap: onGenderTap,
          ),
          SizedBox(height: 12),
          MaterialFilledDropdownField(
            value: state.dateOfBirth,
            hint: Strings.signUpBirthDateHint,
            validator: (v) => DateValidator.validate(v),
            onTap: onDateOfBirthTap,
          ),
          SizedBox(height: 12),
          MaterialFilledTextField(
            inputType: TextInputType.emailAddress,
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            hint: Strings.signUpEmailHint,
            textInputAction: TextInputAction.next,
            controller: emailController,
            inputFormatters: [DenyEmojiFormatter()],
            textCapitalization: TextCapitalization.sentences,
            onChanged: onEmailChanged,
          ),
          SizedBox(height: 4),
          DescriptionTextWidget(
            text: Strings.commonNotRequiredField,
            padding: EdgeInsets.symmetric(horizontal: 4),
          ),
        ],
      ),
    );
  }
}

class _SignUpRegionBlock extends StatelessWidget {
  const _SignUpRegionBlock({
    required this.state,
    required this.onCountryTap,
    required this.onRegionTap,
    required this.onDistrictTap,
  });

  final SignUpState state;
  final VoidCallback onCountryTap;
  final VoidCallback onRegionTap;
  final VoidCallback onDistrictTap;

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      margin: EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Strings.signUpRegionBlock.s(16).w(600).c(context.textPrimary),
          SizedBox(height: 20),
          MaterialFilledDropdownField(
            value: state.selectedCountry?.name ?? "",
            hint: Strings.signUpCountryHint,
            validator: (v) => NotEmptyValidator.validate(v),
            onTap: onCountryTap,
          ),
          SizedBox(height: 12),
          MaterialFilledDropdownField(
            value: state.selectedRegion?.name ?? "",
            hint: Strings.signUpRegionHint,
            validator: (v) => NotEmptyValidator.validate(v),
            onTap: onRegionTap,
          ),
          SizedBox(height: 12),
          MaterialFilledDropdownField(
            value: state.selectedDistrict?.name ?? "",
            hint: Strings.signUpDistrictHint,
            validator: (v) => NotEmptyValidator.validate(v),
            onTap: onDistrictTap,
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SignUpPasswordBlock extends StatelessWidget {
  const _SignUpPasswordBlock({
    required this.state,
    required this.passwordController,
    required this.passwordConfirmController,
    required this.onPasswordChanged,
    required this.onPasswordConfirmChanged,
  });

  final SignUpState state;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onPasswordConfirmChanged;

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      margin: EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Strings.signUpPasswordBlock.s(16).w(600).c(context.textPrimary),
          SizedBox(height: 12),
          MaterialFilledTextField(
            inputType: TextInputType.visiblePassword,
            keyboardType: TextInputType.visiblePassword,
            maxLines: 1,
            hint: Strings.signUpPasswordHint,
            obscureText: true,
            textInputAction: TextInputAction.next,
            controller: passwordController,
            validator: (v) => PasswordValidator.validate(v),
            onChanged: onPasswordChanged,
          ),
          SizedBox(height: 12),
          DescriptionTextWidget(
            text: Strings.signUpPasswordDesc,
            padding: EdgeInsets.symmetric(horizontal: 4),
          ),
          SizedBox(height: 12),
          MaterialFilledTextField(
            inputType: TextInputType.visiblePassword,
            keyboardType: TextInputType.visiblePassword,
            maxLines: 1,
            hint: Strings.signUpPasswordConfirmHint,
            obscureText: true,
            textInputAction: TextInputAction.done,
            controller: passwordConfirmController,
            validator: (confirm) => PasswordConfirmValidator.validate(
              password: state.password,
              confirm: confirm,
            ),
            onChanged: onPasswordConfirmChanged,
          ),
        ],
      ),
    );
  }
}

class _SignUpActionBlock extends StatelessWidget {
  const _SignUpActionBlock({
    required this.state,
    required this.onPrivacyPolicyTap,
    required this.onSubmitTap,
  });

  final SignUpState state;
  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onSubmitTap;

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      margin: EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    ..onTap = onPrivacyPolicyTap,
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
                    ..onTap = onPrivacyPolicyTap,
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
          SizedBox(height: 16),
          MaterialElevatedButton(
            text: Strings.signUpSubmitButton,
            onPressed: onSubmitTap,
            loading: state.isRequestSending,
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
