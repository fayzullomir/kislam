import 'package:koreaislam/data/datasource/network/dto/session/active_session_response.dart';
import 'package:koreaislam/domain/models/session/active_session.dart';

extension ActiveSessionResponseMappers on ActiveSessionResponse {
  ActiveSession toModel(String deviceId) {
    return ActiveSession(
      id: id,
      isCurrentSession: this.deviceId == deviceId,
      userId: userId,
      token: token ?? "",
      uniqueId: uniqueId,
      appVersionCode: appVersionCode ?? 1,
      appVersionName: appVersionName ?? "",
      deviceId: deviceId,
      deviceName: deviceName ?? '',
      deviceModel: deviceModel ?? '',
      appSource: appSource ?? '',
      refreshId: refreshId ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
