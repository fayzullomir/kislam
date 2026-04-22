import 'package:flutter/material.dart';
import 'package:koreaislam/domain/models/chat/chat_info.dart';
import 'package:koreaislam/presentation/widgets/chat/chat_info_widget.dart';

class ChatInfoListWidget extends StatelessWidget {
  final List<ChatInfo> chatInfos;
  final Function(ChatInfo chat) onChatClicked;

  const ChatInfoListWidget({
    super.key,
    required this.chatInfos,
    required this.onChatClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      itemCount: chatInfos.length,
      itemBuilder: (BuildContext buildContext, int index) {
        final item = chatInfos[index];
        return ChatInfoWidget(
          chatInfo: item,
          onClicked: (chat) => onChatClicked(chat),
        );
      },
      separatorBuilder: (BuildContext c, int index) => SizedBox(height: 8),
    );
  }
}
