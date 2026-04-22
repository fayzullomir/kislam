// network_exception.dart

abstract class NetworkException implements Exception {
  final String message;
  final String? endpoint;
  final int? statusCode;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic> extras;
  final DateTime timestamp;

  NetworkException({
    required this.message,
    required this.endpoint,
    required this.statusCode,
    required this.headers,
    Map<String, dynamic>? extras,
  })  : extras = extras ?? {},
        timestamp = DateTime.now();

  String get exceptionName;

  @override
  String toString() => '$exceptionName: $message';
}
