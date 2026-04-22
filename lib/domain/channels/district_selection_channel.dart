import 'package:koreaislam/core/channel/base_channel.dart';
import 'package:koreaislam/domain/models/region/district.dart';

class DistrictSelectionChannel extends BaseChannel<District> {
  DistrictSelectionChannel({super.isBroadcast = true});
}
