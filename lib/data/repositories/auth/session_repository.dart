import 'dart:async';

import 'package:koreaislam/data/datasource/floor/dao/user_entity_dao.dart';
import 'package:koreaislam/data/datasource/network/dto/session/active_session_response.dart';
import 'package:koreaislam/data/datasource/network/dto/session/logout_response.dart';
import 'package:koreaislam/data/datasource/network/dto/session/terminate_session_response.dart';
import 'package:koreaislam/data/datasource/network/services/session_service.dart';
import 'package:koreaislam/data/datasource/preference/auth_preferences.dart';
import 'package:koreaislam/data/datasource/preference/device_preference.dart';
import 'package:koreaislam/data/datasource/preference/fcm_token_preferences.dart';
import 'package:koreaislam/data/datasource/preference/profile_preferences.dart';
import 'package:koreaislam/data/mappers/session_mappers.dart';
import 'package:koreaislam/domain/models/session/active_session.dart';

class SessionRepository {
  final AuthPreferences _authPreferences;
  final DevicePreferences _devicePreferences;
  final FcmTokenPreferences _fcmTokenPreferences;
  final ProfilePreferences _profilePreferences;
  final SessionService _sessionService;
  final UserEntityDao _userEntityDao;

  SessionRepository(
    this._authPreferences,
    this._devicePreferences,
    this._fcmTokenPreferences,
    this._sessionService,
    this._userEntityDao,
    this._profilePreferences,
  );

  Future<void> clearBeforeLogout() async {
    await _authPreferences.clear();
    await _devicePreferences.clear();
    await _fcmTokenPreferences.clear();
    await _userEntityDao.clear();
    await _profilePreferences.clear();
    return;
  }

  Future<List<ActiveSession>> fetchActiveSessions({
    required int page,
    required int size,
  }) async {
    var deviceId = _devicePreferences.deviceSessionId;
    var response = await _sessionService.fetchActiveSessions(
      page: page,
      size: size,
    );
    var rootResponse = ActiveSessionRootResponse.fromJson(response.data);
    return rootResponse.sessions.map((e) => e.toModel(deviceId)).toList();
  }

  Future<TerminateSessionResponse> terminateSession(
    ActiveSession session,
  ) async {
    var response = await _sessionService.terminateSession(session);

    return TerminateSessionResponse.fromJson(response.data);
  }

  Future<LogoutResponse> logout() async {
    var response = await _sessionService.logout();

    return LogoutResponse.fromJson(response.data);
  }
}
