// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'district_response.freezed.dart';
part 'district_response.g.dart';

@freezed
class DistrictResponse with _$DistrictResponse {
  const factory DistrictResponse({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'region_id') required int regionId,
    @JsonKey(name: 'country_id') required int countryId,
  }) = _DistrictResponse;

  factory DistrictResponse.fromJson(Map<String, dynamic> json) =>
      _$DistrictResponseFromJson(json);
}