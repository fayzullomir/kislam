import 'package:koreaislam/data/datasource/network/error/network_exception.dart';
import 'package:koreaislam/data/datasource/network/error/network_exception_extensions.dart';

class SignUpFailedException extends NetworkException {
  SignUpFailedException({
    required super.message,
    required super.endpoint,
    required super.statusCode,
    required super.headers,
    required super.extras,
  });

  @override
  String get exceptionName => "SignUpFailedException";

  Future<void> recordToCrashlytics() =>
      recordThisErrorToCrashlytics(StackTrace.current);
}
