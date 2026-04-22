import 'package:koreaislam/data/error/app_exception.dart';

abstract class AppLocalException extends AppException {
  @override
  bool get isRequiredShowError => false;
}

class NotAuthorizedException implements AppLocalException {
  @override
  bool get isRequiredShowError => true;
}

class NotIdentifiedException implements AppLocalException {
  @override
  bool get isRequiredShowError => true;
}

class StudentNotLoadException implements AppLocalException {
  @override
  bool get isRequiredShowError => false;

}
class GroupNotLoadException implements AppLocalException {
  @override
  bool get isRequiredShowError => false;

}