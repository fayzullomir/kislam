part of 'profile_edit_cubit.dart';

@freezed
class ProfileEditState with _$ProfileEditState {
  const ProfileEditState._();

  const factory ProfileEditState({
    //
    @Default("") String firstName,
    @Default("") String lastName,
    //
    @Default("") String profilePhotoUrl,
    MediaFile? newProfilePhoto,
    //
    @Default(false) bool isCompressing,
    //
    @Default(false) bool isRequestSending,
    //
  }) = _ProfileEditState;

  bool get hasSelectedPhoto => newProfilePhoto != null;

  bool get hasCurrentPhoto => profilePhotoUrl.isNotEmpty;

  bool get showPlaceholder => !hasCurrentPhoto && !hasSelectedPhoto;

  bool get showSelectedPhoto => hasSelectedPhoto;

  bool get showCurrentPhoto => !hasSelectedPhoto && hasCurrentPhoto;

  bool get canSave =>
      firstName.isNotEmpty && lastName.isNotEmpty && !isRequestSending;
}

@freezed
class ProfileEditEvent with _$ProfileEditEvent {
  const factory ProfileEditEvent(ProfileEditEventType type) = _ProfileEditEvent;
}

sealed class ProfileEditEventType {}

class OnEditingDataPrepared extends ProfileEditEventType {
  String firstName;
  String lastName;
  String profilePhotoUrl;

  OnEditingDataPrepared({
    required this.firstName,
    required this.lastName,
    required this.profilePhotoUrl,
  });
}

class OnEditStarted extends ProfileEditEventType {}

class OnEditFinished extends ProfileEditEventType {}

class OnEditFailed extends ProfileEditEventType {}
