import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/repositories/file/file_upload_repository.dart';
import 'package:koreaislam/data/repositories/profile/profile_repository.dart';
import 'package:koreaislam/domain/models/media/file_type.dart';
import 'package:koreaislam/domain/models/media/media_file.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';
import 'package:koreaislam/presentation/support/extensions/extension_message_exts.dart';
import 'package:koreaislam/utils/compress/photo_compress_utils.dart';

part 'profile_edit_cubit.freezed.dart';
part 'profile_edit_state.dart';

@Injectable()
class ProfileEditCubit extends BaseCubit<ProfileEditState, ProfileEditEvent> {
  final FileUploadRepository _fileUploadRepository;
  final ProfileRepository _profileRepository;

  ProfileEditCubit(
    this._fileUploadRepository,
    this._profileRepository,
  ) : super(ProfileEditState()) {
    _getSavedUser();
    _fetchProfile();
  }

  Future<void> _getSavedUser() async {
    updateState((state) => state.copyWith(
          firstName: _profileRepository.userFirstName,
          lastName: _profileRepository.userLastName,
          profilePhotoUrl: _profileRepository.profilePhotoUrl,
        ));

    await Future.delayed(Duration(milliseconds: 100));

    emitEvent(ProfileEditEvent(OnEditingDataPrepared(
      firstName: _profileRepository.userFirstName,
      lastName: _profileRepository.userLastName,
      profilePhotoUrl: _profileRepository.profilePhotoUrl,
    )));
  }

  void _fetchProfile() {
    _profileRepository
        .fetchProfile()
        .initFuture()
        .onStart(() {})
        .onSuccess((data) {
          _getSavedUser();
        })
        .onError((error) {
          AppLog.e("Profile fetch error", error: error);
        })
        .onFinished(() {})
        .executeFuture();
  }

  void setFirstName(String value) {
    updateState((state) => state.copyWith(firstName: value));
  }

  void setLastName(String value) {
    updateState((state) => state.copyWith(lastName: value));
  }

  Future<void> pickPhoto() async {
    try {
      updateState((state) => state.copyWith(isCompressing: true));
      final picker = ImagePicker();
      final photoFile = await picker.pickImage(source: ImageSource.gallery);

      _compressAndSavePhoto(photoFile);
    } catch (e) {
      AppLog.e("pickPhoto error", error: e);
      updateState((state) => state.copyWith(isCompressing: false));
    }
  }

  Future<void> _compressAndSavePhoto(XFile? photo) async {
    if (photo == null) {
      updateState((state) => state.copyWith(isCompressing: false));
      return;
    }

    final compressionResult = await PhotoCompressUtils.compress(photo);

    updateState((state) => state.copyWith(
          newProfilePhoto: MediaFile(
            localFilePath: compressionResult.file.path,
            localMediaFile: compressionResult.file,
          ),
          isCompressing: false,
        ));
  }

  void removeSelectedPhoto() {
    updateState((state) => state.copyWith(newProfilePhoto: null));
  }

  Future<void> updateProfile() async {
    if (states.newProfilePhoto != null) {
      updateState((s) => s.copyWith(isRequestSending: true));

      var file = await _fileUploadRepository.uploadImage(
        states.newProfilePhoto!,
        FileUploadType.userProfile,
      );
      updateState((state) => state.copyWith(newProfilePhoto: file));
    }

    await _profileRepository
        .updateProfile(
          firstName: states.firstName,
          lastName: states.lastName,
          profilePhotoUrl: states.newProfilePhoto?.uploadedFileUrl,
        )
        .initFuture()
        .onStart(() {
          if (states.isRequestSending == false) {
            updateState((s) => s.copyWith(isRequestSending: true));
          }
        })
        .onSuccess((data) {
          updateState((s) => s.copyWith(isRequestSending: false));
          emitEvent(ProfileEditEvent(OnEditFinished()));
        })
        .onError((error) {
          updateState((s) => s.copyWith(isRequestSending: false));
          stateMessageManager.showErrorBottomSheet(error.localizedMessage);
        })
        .onFinished(() {})
        .executeFuture();
  }
}
