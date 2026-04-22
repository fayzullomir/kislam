import 'package:dio/dio.dart';

class RegionService {
  final Dio _dio;

  RegionService(this._dio);

  Future<Response> fetchCountries() {
    return _dio.get("mobile/region/country");
  }

  Future<Response> fetchRegions({required int countryId}) {
    final queryParams = {"country_id": countryId};
    return _dio.get("/mobile/region/", queryParameters: queryParams);
  }

  Future<Response> fetchDistricts({required int regionId}) {
    final queryParams = {"region_id": regionId};
    return _dio.get("mobile/region/district", queryParameters: queryParams);
  }
}
