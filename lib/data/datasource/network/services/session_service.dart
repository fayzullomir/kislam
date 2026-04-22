import 'package:dio/dio.dart';
import 'package:koreaislam/domain/models/session/active_session.dart';

class SessionService {
  final Dio bearerDio;
  final Dio cachedDio;

  SessionService({
    required this.bearerDio,
    required this.cachedDio,
  });

  Future<Response> fetchActiveSessions({
    required int page,
    required int size,
  }) {
    var queryParameters = {
      "page": page,
      "size": size,
    };
    return bearerDio.get(
      "mobile/auth/sessions",
      queryParameters: queryParameters,
    );
  }

  Future<Response> terminateSession(ActiveSession session) {
    return bearerDio.delete("mobile/auth/session/${session.id}");
  }

  Future<Response> logout() {
    return cachedDio.post("mobile/auth/session/logout");
  }
}
