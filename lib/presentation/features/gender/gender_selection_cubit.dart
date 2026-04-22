import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/domain/channels/gender_selection_channel.dart';
import 'package:koreaislam/domain/models/gender/gender.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'gender_selection_cubit.freezed.dart';
part 'gender_selection_state.dart';

@Injectable()
class GenderSelectionCubit
    extends BaseCubit<GenderSelectionState, GenderSelectionEvent> {
  final GenderSelectionChannel _genderSelectionChannel;

  GenderSelectionCubit(
    this._genderSelectionChannel,
  ) : super(GenderSelectionState());

  void setInitialData(Gender? gender) {
    updateState((state) => state.copyWith(selectedGender: gender));
  }

  void setSelectedGender(Gender gender) async {
    _genderSelectionChannel.add(gender);
  }
}
