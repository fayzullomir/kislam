import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/date_extensions.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/domain/models/chat/chat_info.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/widgets/material/material_card.dart';
import 'package:koreaislam/presentation/widgets/image/network_circle_image_widget.dart';

class ChatInfoWidget extends StatelessWidget {
  final ChatInfo chatInfo;
  final Function(ChatInfo chat) onClicked;

  const ChatInfoWidget({
    super.key,
    required this.chatInfo,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              _buildChatImage(),
              SizedBox(width: 12),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChatName(context),
                    SizedBox(height: 6),
                    _buildLastMessage(context),
                    SizedBox(height: 4),
                    _buildLastMessageTime(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatImage() {
    return NetworkCircleImageWidget(
      imageUrl: chatInfo.imageUrl,
      width: 56,
      height: 56,
    );
  }

  Widget _buildChatName(BuildContext context) {
    return chatInfo.name
        .s(16)
        .w(500)
        .c(context.textPrimary)
        .copyWith(maxLines: 3, overflow: TextOverflow.ellipsis);
  }

  Widget _buildLastMessage(BuildContext context) {
    return chatInfo.lastMessage
        .s(13)
        .w(400)
        .c(context.textSecondary)
        .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis);
  }

  Widget _buildLastMessageTime(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        chatInfo.lastMessageTime
            .toDateString(outputFormat: "hh:mm")
            .s(13)
            .w(400)
            .c(context.textSecondary)
            .copyWith(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
      ],
    );
  }
}
