import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/enum/enums.dart';
import 'package:koreaislam/core/handler/future_handler.dart';
import 'package:koreaislam/data/repositories/region/region_repository.dart';
import 'package:koreaislam/domain/channels/country_selection_channel.dart';
import 'package:koreaislam/domain/models/region/country.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'country_selection_cubit.freezed.dart';
part 'country_selection_state.dart';

@Injectable()
class CountrySelectionCubit
    extends BaseCubit<CountrySelectionState, CountrySelectionEvent> {
  final CountrySelectionChannel _countrySelectionChannel;
  final RegionRepository _regionRepository;

  CountrySelectionCubit(
    this._countrySelectionChannel,
    this._regionRepository,
  ) : super(CountrySelectionState());

  void setInitialData(Country? country) {
    updateState((state) => state.copyWith(
          selectedCountry: country,
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
        .fetchCountries()
        .initFuture()
        .onStart(() {
          updateState((state) => state.copyWith(
                countriesState: LoadingState.loading,
              ));
        })
        .onSuccess((data) {
          updateState((state) => state.copyWith(
                countries: data,
                countriesState:
                    data.isEmpty ? LoadingState.empty : LoadingState.success,
              ));
        })
        .onError((error) {
          updateState((state) => state.copyWith(
                countriesState: LoadingState.error,
              ));
        })
        .onFinished(() {})
        .executeFuture();
  }

  void setSelectedCountry(Country country) async {
    _countrySelectionChannel.add(country);
  }
}
