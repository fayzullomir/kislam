class AppNotification {
  final int id;
  final int? senderId;
  final String? senderType;
  final int? receiverId;
  final String? receiverType;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final int typeIndex;
  final bool isSent;
  final int attemptCount;
  bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    this.senderId,
    this.senderType,
    this.receiverId,
    this.receiverType,
    required this.title,
    required this.body,
    this.data,
    required this.typeIndex,
    required this.isSent,
    required this.attemptCount,
    required this.isRead,
    required this.createdAt,
  });

  void markAsRead() {
    isRead = true;
  }
}