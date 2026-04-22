import 'package:koreaislam/core/channel/base_channel.dart';
import 'package:koreaislam/domain/models/gender/gender.dart';

class GenderSelectionChannel extends BaseChannel<Gender> {
  GenderSelectionChannel({super.isBroadcast = true});
}
