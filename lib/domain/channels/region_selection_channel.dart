import 'package:koreaislam/core/channel/base_channel.dart';
import 'package:koreaislam/domain/models/region/region.dart';

class RegionSelectionChannel extends BaseChannel<Region> {
  RegionSelectionChannel({super.isBroadcast = true});
}
