class ActiveSession {
  final int id;
  final bool isCurrentSession;
  final int userId;
  final String token;
  final String uniqueId;
  final int appVersionCode;
  final String appVersionName;
  final String deviceId;
  final String deviceName;
  final String deviceModel;
  final String appSource;
  final String refreshId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ActiveSession({
    required this.id,
    required this.isCurrentSession,
    required this.userId,
    required this.token,
    required this.uniqueId,
    required this.appVersionCode,
    required this.appVersionName,
    required this.deviceId,
    required this.deviceName,
    required this.deviceModel,
    required this.appSource,
    required this.refreshId,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isNotCurrentSession => !isCurrentSession;
}
