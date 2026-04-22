
class ChatUser{
  final int id;
  final String firstName;
  final String lastName;
  final String chatUid;
  final String chatUsername;
  final String? avatar;

  ChatUser({required this.id, required this.firstName, required this.lastName, required this.chatUid, required this.chatUsername, required this.avatar});


  @override
  String toString() {
    return 'ChatUser{id: $id, firstName: $firstName, lastName: $lastName, chatUid: $chatUid, chatUsername: $chatUsername, avatar: $avatar}';
  }
}