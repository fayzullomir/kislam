import 'package:koreaislam/data/datasource/network/dto/region/country_response.dart';
import 'package:koreaislam/data/datasource/network/dto/region/district_response.dart';
import 'package:koreaislam/data/datasource/network/dto/region/region_response.dart';
import 'package:koreaislam/domain/models/region/country.dart';
import 'package:koreaislam/domain/models/region/district.dart';
import 'package:koreaislam/domain/models/region/region.dart';

extension CountryResponseMappers on CountryResponse {
  Country toModel() {
    return Country(
      id: id,
      name: name,
    );
  }
}

extension RegionResponseMappers on RegionResponse {
  Region toModel() {
    return Region(
      id: id,
      name: name,
      countryId: countryId,
    );
  }
}

extension DistrictResponseMappers on DistrictResponse {
  District toModel() {
    return District(
      id: id,
      name: name,
      regionId: regionId,
      countryId: countryId,
    );
  }
}
