import 'package:koreaislam/domain/models/chat/chat_info.dart';

class ChatRepository {

  ChatRepository();

  Future<List<ChatInfo>> fetchUserChats() async {
    await Future.delayed(Duration(milliseconds: 500));

    return [];
  }
}
