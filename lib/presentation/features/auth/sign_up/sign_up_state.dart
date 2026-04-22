part of 'sign_up_cubit.dart';

@freezed
class SignUpState with _$SignUpState {
  const SignUpState._();

  const factory SignUpState({
    //
    @Default("") String phoneNumber,
    @Default("") String userType,
    //
    @Default("") String firstName,
    @Default("") String lastName,
    Gender? selectedGender,
    @Default("") String dateOfBirth,
    String? email,
    //
    String? profilePhoto,
    //
    Country? selectedCountry,
    Region? selectedRegion,
    District? selectedDistrict,
    //
    @Default("") String password,
    @Default("") String passwordConfirm,
    //
    @Default(false) bool isRequestSending,
    @Default(false) bool isFaceIDChecking,
    //
  }) = _SignUpState;
}

@freezed
class SignUpEvent with _$SignUpEvent {
  const factory SignUpEvent(SignUpEventType type) = _SignUpEvent;
}

sealed class SignUpEventType {}

class OpenHomePage extends SignUpEventType {}
