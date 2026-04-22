import 'package:flutter_image_compress/flutter_image_compress.dart';

class MediaFile {
  String? uploadedFileUrl;
  String? localFileName;
  String? localFilePath;
  String? localFileExtension;
  XFile? localMediaFile;

  MediaFile({
    this.uploadedFileUrl,
    this.localFileName,
    this.localFilePath,
    this.localFileExtension,
    this.localMediaFile,
  });

  MediaFile copy() {
    return MediaFile(
      uploadedFileUrl: uploadedFileUrl,
      localFileName: localFileName,
      localFilePath: localFilePath,
      localFileExtension: localFileExtension,
      localMediaFile: localMediaFile,
    );
  }

  bool isUploaded() {
    return uploadedFileUrl?.isNotEmpty == true;
  }

  bool isSame(MediaFile other) {
    return localMediaFile?.path != null &&
        localMediaFile?.path == other.localMediaFile?.path;
  }

  bool isNotUploaded() {
    return uploadedFileUrl == null || uploadedFileUrl?.trim().isEmpty == true;
  }
}
