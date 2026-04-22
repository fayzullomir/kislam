import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/handler/stream_handler.dart';
import 'package:koreaislam/core/handler/stream_subscriptions.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/repositories/config/config_repository.dart';
import 'package:koreaislam/data/repositories/profile/profile_repository.dart';
import 'package:koreaislam/domain/channels/logout_event_channel.dart';
import 'package:koreaislam/domain/models/logout_event/logout_event_type.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

part 'profile_cubit.freezed.dart';
part 'profile_state.dart';

class ProfileCubit extends BaseCubit<ProfileState, ProfileEvent> {
  final ConfigRepository _configRepository;
  final LogoutEventChannel _logoutEventChannel;
  final ProfileRepository _profileRepository;

  ProfileCubit(
    this._configRepository,
    this._logoutEventChannel,
    this._profileRepository,
  ) : super(ProfileState()) {
    _readSavedProfile();
    _watchSavedProfile();
  }

  final _subscriptions = StreamSubscriptions();

  @override
  Future<void> close() {
    _subscriptions.cancelAll();
    return super.close();
  }

  void _readSavedProfile() {
    updateState((state) => state.copyWith(
          firstName: _profileRepository.userFirstName,
          lastName: _profileRepository.userLastName,
          phoneNumber: _profileRepository.userPhoneNumber,
          profilePhotoUrl: _profileRepository.profilePhotoUrl,
        ));
  }

  void _watchSavedProfile() {
    _subscriptions.add(
      _configRepository.isAuthorizedStream
          .initStream()
          .onData((d) => updateState((s) => s.copyWith(isAuthorized: d)))
          .execute(),
    );

    _subscriptions.add(
      _profileRepository.firstNameStream
          .initStream()
          .onData((d) => updateState((s) => s.copyWith(firstName: d)))
          .execute(),
    );

    _subscriptions.add(
      _profileRepository.lastNameStream
          .initStream()
          .onData((d) => updateState((s) => s.copyWith(lastName: d)))
          .execute(),
    );

    _subscriptions.add(
      _profileRepository.phoneNumberStream
          .initStream()
          .onData((d) => updateState((s) => s.copyWith(phoneNumber: d)))
          .execute(),
    );

    _subscriptions.add(
      _profileRepository.profilePhotoStream
          .initStream()
          .onData((d) => updateState((s) => s.copyWith(profilePhotoUrl: d)))
          .execute(),
    );
  }

  launchDeleteAccountUrl() async {
    try {
      var url = Uri.parse("https://koreaislam.org/delete-account");
      await launchUrl(url);
    } catch (e) {
      AppLog.e("launchDeleteAccountUrl error: $e");
    }
  }

  Future<void> logOut() async {
    try {
      AppLog.d("logOut call");
      _logoutEventChannel.add(LogoutEvent.onLogoutFromUI);
    } catch (e) {
      stateMessageManager.showErrorSnackBar(Strings.commonEmptyMessage);
    }
  }
}
