import 'package:koreaislam/data/datasource/network/services/file_upload_service.dart';
import 'package:koreaislam/domain/models/media/file_type.dart';
import 'package:koreaislam/domain/models/media/media_file.dart';

class FileUploadRepository {
  final FileUploadService _fileUploadService;

  FileUploadRepository(
    this._fileUploadService,
  );

  Future<MediaFile> uploadImage(
    MediaFile file,
    FileUploadType fileUploadType,
  ) async {
    var response = await _fileUploadService.uploadImage(
      file.localMediaFile!,
      fileUploadType,
    );
    var url = response.data['url'];
    if (url != null && url is String) {
      return file..uploadedFileUrl = url;
    }

    throw Exception("Rasm yuklashda xatolik");
  }

  Future<MediaFile> uploadVideo(
    MediaFile file,
    FileUploadType fileUploadType,
  ) async {
    var response = await _fileUploadService.uploadVideo(
      file.localMediaFile!,
      fileUploadType,
    );
    var url = response.data['url'];
    if (url is String) {
      return file..uploadedFileUrl = url;
    }

    throw Exception("Rasm yuklashda xatolik");
  }
}
