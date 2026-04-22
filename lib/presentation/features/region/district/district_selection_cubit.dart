import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/enum/enums.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/data/repositories/region/region_repository.dart';
import 'package:koreaislam/domain/channels/district_selection_channel.dart';
import 'package:koreaislam/domain/models/region/district.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'district_selection_cubit.freezed.dart';
part 'district_selection_state.dart';

@Injectable()
class DistrictSelectionCubit
    extends BaseCubit<DistrictSelectionState, DistrictSelectionEvent> {
  final DistrictSelectionChannel _districtSelectionChannel;
  final RegionRepository _regionRepository;

  DistrictSelectionCubit(
    this._districtSelectionChannel,
    this._regionRepository,
  ) : super(DistrictSelectionState());

  void setInitialData(int regionId, District? district) {
    updateState((state) => state.copyWith(
          selectedRegionId: regionId,
          selectedDistrict: district,
        ));

    loadData();
  }

  void loadData() {
    fetchDistricts();
  }

  void reloadData() {
    fetchDistricts();
  }

  void fetchDistricts() async {
    _regionRepository
        .fetchDistricts(regionId: states.selectedRegionId)
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(
                districtsState: LoadingState.loading,
              ));
        })
        .onSuccess((data) {
          updateState((state) => state.copyWith(
                districts: data,
                districtsState:
                    data.isEmpty ? LoadingState.empty : LoadingState.success,
              ));
        })
        .onError((error) {
          updateState((state) => state.copyWith(
                districtsState: LoadingState.error,
              ));
        })
        .onFinished(() {})
        .executeFuture();
  }

  void setSelectedDistrict(District district) async {
    _districtSelectionChannel.add(district);
  }
}
