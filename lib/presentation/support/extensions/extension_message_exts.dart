import 'package:koreaislam/core/gen/localization/strings.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/data/error/app_locale_exception.dart';
import 'package:koreaislam/data/error/app_network_exception.dart';

extension ExceptionMessageExts on Exception {
  String get localizedMessage {
    AppLog.d("localizedMessage => Exception $this");
    if (this is AppNetworkException) {
      AppLog.d("localizedMessage => AppNetworkException $this");
      return (this as AppNetworkException).localizedMessage;
    } else if (this is AppLocalException) {
      AppLog.d("localizedMessage => AppLocalException $this");
      return (this as AppLocalException).localizedMessage;
    } else {
      AppLog.d("localizedMessage => e = $toString()");
      return Strings.messageResponseError;
    }
  }
}

extension ObjectExceptionExts on Object {
  String get localizedMessage {
    if (this is Exception) {
      return (this as Exception).localizedMessage;
    } else {
      return toString();
    }
  }
}

extension AppLocalxceptionMessageExts on AppLocalException {
  String get localizedMessage {
    if (this is NotAuthorizedException) {
      return Strings.messageUserNotAuthorized;
    }
    if (this is NotIdentifiedException) {
      return Strings.messageUserIdentityNotVerified;
    }
    return Strings.messageUnknownError;
  }
}

extension AppNetworkExceptionMessageExts on AppNetworkException {
  String get localizedMessage {
    final exception = this;
    if (exception is AppNetworkConnectionException) {
      return Strings.messageConnectionError;
    }
    if (exception is AppNetworkDioException) {
      return exception.message ?? Strings.messageResponseError;
    }
    if (exception is AppNetworkHttpException) {
      switch (exception.statusCode) {
        case 400:
          return exception.message ?? Strings.messageBadRequestError;
        case 401:
          return exception.message ?? Strings.messageBadRequestError;
        case 403:
          return exception.message ?? Strings.messageForbiddenError;
        case 404:
          return exception.message ?? Strings.messageNotFoundError;
        case 500:
          return exception.message ?? Strings.messageInternalServerError;
      }
    }
    AppLog.d("localizedMessage => Default Exception");
    return Strings.messageUnknownError;
  }
}
