import 'package:koreaislam/domain/models/service/service_type.dart';

class ServiceRepository {
  ServiceRepository();

  Future<List<ServiceType>> fetchAvailableServices() async {
    Future.delayed(const Duration(milliseconds: 150));
    return ServiceType.values;
  }
}
