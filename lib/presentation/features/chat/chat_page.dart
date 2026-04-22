import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koreaislam/core/extensions/text_extensions.dart';
import 'package:koreaislam/domain/models/chat/chat_user.dart';
import 'package:koreaislam/presentation/support/cubit/base_page.dart';
import 'package:koreaislam/presentation/widgets/state/loader_state_widget.dart';

import 'chat_cubit.dart';

@RoutePage()
class ChatPage extends BasePage<ChatCubit, ChatState, ChatEvent> {
  final ChatUser chatUser;

  const ChatPage(this.chatUser, {super.key});

  @override
  void onWidgetCreated(BuildContext context) {
    cubit(context)
        .getRocketChatUrlForUser(targetUsername: chatUser.chatUsername);
  }

  @override
  Widget onWidgetBuild(BuildContext context, ChatState state) {
    return Scaffold(
        resizeToAvoidBottomInset: true, body: _buildBody(context, state));
  }

  Widget _buildBody(BuildContext context, ChatState state) {
    return LoaderStateWidget(
      loadingState: state.pageState,
      successBody: _buildSuccess(context, state),
      loadingBody: _buildLoad(),
    );
  }

  Widget _buildSuccess(BuildContext context, ChatState state) {
    return Container(
      child: "Chat".s(15),
    );
  }

  Widget _buildLoad() {
    return Container();
  }
}
