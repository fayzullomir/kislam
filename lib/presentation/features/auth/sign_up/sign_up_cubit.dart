import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/extensions/string_extensions.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/datasource/preference/profile_preferences.dart';
import 'package:koreaislam/data/repositories/auth/sign_up_repository.dart';
import 'package:koreaislam/data/repositories/profile/profile_repository.dart';
import 'package:koreaislam/domain/channels/country_selection_channel.dart';
import 'package:koreaislam/domain/channels/district_selection_channel.dart';
import 'package:koreaislam/domain/channels/gender_selection_channel.dart';
import 'package:koreaislam/domain/channels/region_selection_channel.dart';
import 'package:koreaislam/domain/models/gender/gender.dart';
import 'package:koreaislam/domain/models/region/country.dart';
import 'package:koreaislam/domain/models/region/district.dart';
import 'package:koreaislam/domain/models/region/region.dart';
import 'package:koreaislam/domain/models/user/user_role.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';
import 'package:koreaislam/presentation/support/extensions/extension_message_exts.dart';
import 'package:url_launcher/url_launcher.dart';

part 'sign_up_cubit.freezed.dart';
part 'sign_up_state.dart';

@injectable
class SignUpCubit extends BaseCubit<SignUpState, SignUpEvent> {
  final CountrySelectionChannel _countrySelectionChannel;
  final DistrictSelectionChannel _districtSelectionChannel;
  final GenderSelectionChannel _genderSelectionChannel;
  final ProfilePreferences _profilePreferences;
  final ProfileRepository _profileRepository;
  final RegionSelectionChannel _regionSelectionChannel;
  final SignUpRepository _signUpRepository;

  SignUpCubit(
    this._countrySelectionChannel,
    this._districtSelectionChannel,
    this._genderSelectionChannel,
    this._profilePreferences,
    this._profileRepository,
    this._regionSelectionChannel,
    this._signUpRepository,
  ) : super(const SignUpState()) {
    _subscribeStreams();
  }

  UserRole get userRole => _profilePreferences.userRole;

  StreamSubscription? _countrySubs;
  StreamSubscription? _districtSubs;
  StreamSubscription? _genderSubs;
  StreamSubscription? _regionSubs;

  void _subscribeStreams() {
    _countrySubs?.cancel();
    _countrySubs = _countrySelectionChannel.listen((country) {
      updateState((state) => state.copyWith(
            selectedCountry: country,
            selectedRegion: null,
            selectedDistrict: null,
          ));
    });

    _districtSubs?.cancel();
    _districtSubs = _districtSelectionChannel.listen((district) {
      updateState((state) => state.copyWith(selectedDistrict: district));
    });

    _genderSubs?.cancel();
    _genderSubs = _genderSelectionChannel.listen((gender) {
      updateState((state) => state.copyWith(selectedGender: gender));
    });

    _regionSubs?.cancel();
    _regionSubs = _regionSelectionChannel.listen((region) {
      updateState((state) => state.copyWith(
            selectedRegion: region,
            selectedDistrict: null,
          ));
    });
  }

  @override
  Future<void> close() {
    _districtSubs?.cancel();
    _genderSubs?.cancel();
    _regionSubs?.cancel();

    return super.close();
  }

  void setInitialData({
    required String phoneNumber,
    required String userType,
  }) {
    updateState((state) => state.copyWith(
          phoneNumber: phoneNumber,
          userType: userType,
        ));
  }

  void setPhoneNumber(String phoneNumber) {
    updateState((state) => state.copyWith(
          phoneNumber: phoneNumber.normalized,
        ));
  }

  void setEnteredFirstName(String firstName) {
    updateState((state) => state.copyWith(firstName: firstName));
  }

  void setEnteredLastName(String lastName) {
    updateState((state) => state.copyWith(lastName: lastName));
  }

  void setDateOfBirth(String dateOfBirth) {
    updateState((state) => state.copyWith(dateOfBirth: dateOfBirth));
  }

  void setEnteredEmail(String email) {
    updateState((state) => state.copyWith(email: email));
  }

  void setEnteredPassword(String password) {
    updateState((state) => state.copyWith(password: password));
  }

  void setEnteredPasswordConfirm(String password) {
    updateState((state) => state.copyWith(passwordConfirm: password));
  }

  Future<void> signUp() async {
    _signUpRepository
        .signUp(
          userType: states.userType,
          phoneNumber: states.phoneNumber,
          firstName: states.firstName,
          lastName: states.lastName,
          gender: states.selectedGender!,
          dateOfBirth: states.dateOfBirth,
          email: states.email,
          profilePhoto: states.profilePhoto,
          country: states.selectedCountry!,
          region: states.selectedRegion!,
          district: states.selectedDistrict!,
          password: states.password,
        )
        .initFuture()
        .onStart(() {
          AppLog.e("SignUp request started");
          updateState((state) => state.copyWith(isRequestSending: true));
        })
        .onSuccess((data) {
          AppLog.e("SignUp request success: $data");
          _fetchProfile();
        })
        .onError((error) {
          AppLog.e("SignUp request error: $error");
          AppLog.e("SignUp request error message: ${error.localizedMessage}");
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
          emitEvent(SignUpEvent(OpenHomePage()));
        })
        .onError((error) {
          updateState((state) => state.copyWith(isRequestSending: false));
          stateMessageManager.showErrorBottomSheet(error.localizedMessage);
        })
        .onFinished(() {})
        .executeFuture();
  }

  launchURLApp() async {
    try {
      var url = Uri.parse("https://koreaislam.org/privacy-policy");
      await launchUrl(url);
    } catch (e) {
      stateMessageManager.showErrorSnackBar(
          e.toString(), "Urlni parse qilishda xatolik yuz berdi");
    }
  }
}
