class ChatInfo {
  final String id;
  final String name;
  final String imageUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isActive;
  final bool isUmrahGroupChat;

  ChatInfo({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isActive,
    required this.isUmrahGroupChat,
  });
}
