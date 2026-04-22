import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:koreaislam/data/repositories/language/language_repository.dart';
import 'package:koreaislam/domain/channels/language_selection_channel.dart';
import 'package:koreaislam/domain/models/language/language.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'change_language_cubit.freezed.dart';
part 'change_language_state.dart';

@Injectable()
class ChangeLanguageCubit
    extends BaseCubit<ChangeLanguageState, ChangeLanguageEvent> {
  final LanguageRepository _languageRepository;
  final LanguageSelectionChannel _languageSelectionChannel;

  ChangeLanguageCubit(
    this._languageRepository,
    this._languageSelectionChannel,
  ) : super(ChangeLanguageState()) {
    _getLanguages();
  }

  void _getLanguages() async {
    final language = _languageRepository.getLanguage();
    updateState((state) => state.copyWith(selectedLanguage: language));
  }

  void setSelectedLanguage(Language language) async {
    await _languageRepository.setLanguage(language);

    _languageSelectionChannel.add(language);
  }
}
