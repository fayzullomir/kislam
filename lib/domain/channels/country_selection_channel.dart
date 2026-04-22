import 'package:koreaislam/core/channel/base_channel.dart';
import 'package:koreaislam/domain/models/region/country.dart';

class CountrySelectionChannel extends BaseChannel<Country> {
  CountrySelectionChannel({super.isBroadcast = true});
}
