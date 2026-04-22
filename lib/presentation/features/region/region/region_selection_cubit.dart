import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/enum/enums.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/data/repositories/region/region_repository.dart';
import 'package:koreaislam/domain/channels/region_selection_channel.dart';
import 'package:koreaislam/domain/models/region/region.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'region_selection_cubit.freezed.dart';
part 'region_selection_state.dart';

@Injectable()
class RegionSelectionCubit
    extends BaseCubit<RegionSelectionState, RegionSelectionEvent> {
  final RegionRepository _regionRepository;
  final RegionSelectionChannel _regionSelectionChannel;

  RegionSelectionCubit(
    this._regionRepository,
    this._regionSelectionChannel,
  ) : super(RegionSelectionState());

  void setInitialData(int initialCountryId, Region? region) {
    updateState((state) => state.copyWith(
          selectedCountryId: initialCountryId,
          selectedRegion: region,
        ));

    loadData();
  }

  void loadData() {
    fetchRegions();
  }

  void reloadData() {
    fetchRegions();
  }

  void fetchRegions() async {
    _regionRepository
        .fetchRegions(countryId: states.selectedCountryId)
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(
                regionsState: LoadingState.loading,
              ));
        })
        .onSuccess((data) {
          updateState((state) => state.copyWith(
                regions: data,
                regionsState:
                    data.isEmpty ? LoadingState.empty : LoadingState.success,
              ));
        })
        .onError((error) {
          updateState((state) => state.copyWith(
                regionsState: LoadingState.error,
              ));
        })
        .onFinished(() {})
        .executeFuture();
  }

  void setSelectedRegion(Region region) async {
    _regionSelectionChannel.add(region);
  }
}
