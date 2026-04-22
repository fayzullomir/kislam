part of 'quran_cubit.dart';

@freezed
class QuranState with _$QuranState {
  const QuranState._();

  @freezed
  const factory QuranState({
    //
    @Default([]) List<ServiceType> services,
    @Default(LoadingState.loading) servicesState,
    //
  }) = _QuranState;
}

@freezed
class QuranEvent with _$QuranEvent {
  const factory QuranEvent() = _QuranEvent;
}
