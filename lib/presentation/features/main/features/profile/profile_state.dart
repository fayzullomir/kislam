part of 'profile_cubit.dart';

@freezed
class ProfileState with _$ProfileState {
  const ProfileState._();

  const factory ProfileState({
//
    @Default(false) bool isAuthorized,
//
    @Default("") String firstName,
    @Default("") String lastName,
    @Default("") String profilePhotoUrl,
    @Default("") String phoneNumber,
//
  }) = _ProfileState;

  String get fullName => '$firstName $lastName'.trim();
}

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent() = _ProfileEvent;
}
