import 'package:koreaislam/domain/models/language/language.dart';

abstract class TemporarilyDataHolder {
  static String fcmToken = "";
  static String accessToken = "";
  static Language currentLanguage = Language.russianRu;

  static void clearTokenValues() {
    fcmToken = "";
    accessToken = "";
  }
}
