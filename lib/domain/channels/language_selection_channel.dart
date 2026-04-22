import 'package:koreaislam/core/channel/base_channel.dart';
import 'package:koreaislam/domain/models/language/language.dart';

class LanguageSelectionChannel extends BaseChannel<Language> {
  LanguageSelectionChannel({super.isBroadcast = true});
}
