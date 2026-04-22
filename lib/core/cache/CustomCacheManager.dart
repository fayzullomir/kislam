import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:koreaislam/data/datasource/preference/temporarily_data_holder.dart';

class CustomCacheManager {
  static const keyCachedImages = 'cached-network-images';
  static CacheManager imageCacheManager = CacheManager(
    Config(
      keyCachedImages,
      stalePeriod: const Duration(days: 3), // Maximum saving days
      maxNrOfCacheObjects: 150, // Maximum number of files
      fileService: AuthHttpFileService(),
    ),
  );
}

class AuthHttpFileService extends FileService {
  final http.Client _httpClient;

  AuthHttpFileService() : _httpClient = http.Client();

  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    var token = TemporarilyDataHolder.accessToken;
    final mergedHeaders = <String, String>{
      ...?headers,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    // AppLog.e("CustomCacheManager -> Downloading file from $url with headers: $mergedHeaders");

    final request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(mergedHeaders);

    final response = await _httpClient.send(request);

    return HttpGetResponse(response);
  }
}
