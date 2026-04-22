import 'package:koreaislam/core/channel/base_channel.dart';
import 'package:koreaislam/domain/models/login/login_event.dart';

class LoginEventChannel extends BaseChannel<LoginEvent> {
  LoginEventChannel({super.isBroadcast = true});
}
