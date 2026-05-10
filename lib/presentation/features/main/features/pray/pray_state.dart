part of 'pray_cubit.dart';

@freezed
class PrayState with _$PrayState {
  const PrayState._();

  // Skeleton state for the Prayer Guide. Fleshed out in Phase 4 — we just
  // need a non-empty cubit so the route registers cleanly.
  const factory PrayState({
    @Default('Dhuhr') String prayerName,
    @Default(0) int currentStep,
    @Default(7) int totalSteps,
  }) = _PrayState;
}

@freezed
class PrayEvent with _$PrayEvent {
  const factory PrayEvent() = _PrayEvent;
}
