import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:koreaislam/domain/models/media/file_type.dart';

class FileUploadService {
  final Dio _dio;

  FileUploadService(Dio dio) : _dio = dio;

  Future<Response> uploadImage(
    XFile xFile,
    FileUploadType fileUploadType,
  ) async {
    var queryParams = {
      'bucket_type': fileUploadType.apiValue,
    };
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(xFile.path, filename: xFile.name),
    });

    return await _dio.post(
      'mobile/file/photo',
      data: formData,
      queryParameters: queryParams,
    );
  }

  Future<Response> uploadVideo(
    XFile xFile,
    FileUploadType fileUploadType,
  ) async {
    var queryParams = {
      'bucket_type': fileUploadType.apiValue,
    };
    var formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(xFile.path, filename: xFile.name),
    });

    return await _dio.post(
      'mobile/file/video',
      data: formData,
      queryParameters: queryParams,
    );
  }
}
