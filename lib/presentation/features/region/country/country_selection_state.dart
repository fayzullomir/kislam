part of 'country_selection_cubit.dart';

@freezed
class CountrySelectionState with _$CountrySelectionState {
  const factory CountrySelectionState({
    //
    @Default([]) List<Country> countries,
    @Default(LoadingState.loading) LoadingState countriesState,
    //
    Country? selectedCountry,
    //
  }) = _CountrySelectionState;
}

@freezed
class CountrySelectionEvent with _$CountrySelectionEvent {
  const factory CountrySelectionEvent() = _CountrySelectionEvent;
}
