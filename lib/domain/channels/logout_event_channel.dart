import 'package:koreaislam/core/channel/base_channel.dart';
import 'package:koreaislam/domain/models/logout_event/logout_event_type.dart';

class LogoutEventChannel extends BaseChannel<LogoutEvent> {
  LogoutEventChannel({super.isBroadcast = true});
}
