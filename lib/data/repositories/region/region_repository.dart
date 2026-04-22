import 'package:koreaislam/data/datasource/network/dto/region/country_response.dart';
import 'package:koreaislam/data/datasource/network/dto/region/district_response.dart';
import 'package:koreaislam/data/datasource/network/dto/region/region_response.dart';
import 'package:koreaislam/data/datasource/network/services/region_service.dart';
import 'package:koreaislam/data/mappers/region_mappers.dart';
import 'package:koreaislam/domain/models/region/country.dart';
import 'package:koreaislam/domain/models/region/district.dart';
import 'package:koreaislam/domain/models/region/region.dart';

class RegionRepository {
  final RegionService _regionService;

  RegionRepository(this._regionService);

  Future<List<Country>> fetchCountries() async {
    var response = await _regionService.fetchCountries();

    return (response.data as List<dynamic>)
        .map((e) => CountryResponse.fromJson(e))
        .map((e) => e.toModel())
        .toList();
  }

  Future<List<Region>> fetchRegions({required int countryId}) async {
    var response = await _regionService.fetchRegions(countryId: countryId);

    return (response.data as List<dynamic>)
        .map((e) => RegionResponse.fromJson(e))
        .map((e) => e.toModel())
        .toList();
  }

  Future<List<District>> fetchDistricts({required int regionId}) async {
    var response = await _regionService.fetchDistricts(regionId: regionId);

    return (response.data as List<dynamic>)
        .map((e) => DistrictResponse.fromJson(e))
        .map((e) => e.toModel())
        .toList();
  }
}
