part of 'knowledge_cubit.dart';

@freezed
class KnowledgeState with _$KnowledgeState {
  const KnowledgeState._();

  @freezed
  const factory KnowledgeState() = _KnowledgeState;
}

@freezed
class KnowledgeEvent with _$KnowledgeEvent {
  const factory KnowledgeEvent() = _KnowledgeEvent;
}
