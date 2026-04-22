import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'knowledge_cubit.freezed.dart';
part 'knowledge_state.dart';

@injectable
class KnowledgeCubit extends BaseCubit<KnowledgeState, KnowledgeEvent> {
  KnowledgeCubit() : super(KnowledgeState());
}
