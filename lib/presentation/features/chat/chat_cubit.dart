import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:koreaislam/core/enum/enums.dart';
import 'package:koreaislam/core/log/logger/app_log.dart';
import 'package:koreaislam/presentation/support/cubit/base_cubit.dart';

part 'chat_cubit.freezed.dart';
part 'chat_state.dart';

@injectable
class ChatCubit extends BaseCubit<ChatState, ChatEvent> {

  ChatCubit() : super(ChatState());

  String get userRocketChatToken => "_userPreferences.userRocketChatToken";

  @override
  Future<void> close() async {
    return super.close();
  }

  reload() {}

  void setSelectedDate(DateTime item) {
    updateState((state) => state.copyWith(selectedDate: item));
    reload();
  }

  void getRocketChatUrlForUser({
    required String targetUsername, // rocket_chat.chatUsername
  }) async {
    const token = "_userPreferences.userRocketChatToken";
    const userId = "_userPreferences.userRocketChatUid";
    const baseUrl = 'https://chat.koreaislam.org';
    final createRoomUrl = Uri.parse('$baseUrl/api/v1/im.create');

    final response = await http.post(
      createRoomUrl,
      headers: {
        'X-Auth-Token': token,
        'X-User-Id': userId,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': targetUsername}),
    );
    AppLog.d("getRocketChatUrlForUser ${response.statusCode}");
    if (response.statusCode == 200) {
      final chatUrl = '$baseUrl/direct/$targetUsername?layout=light';
      updateState((state) =>
          state.copyWith(url: chatUrl, pageState: LoadingState.success));
    } else {
      return null;
    }
  }
}
