import 'package:hpanelx/src/modules/domains/data/models/domain_model.dart';
import 'package:hpanelx/src/modules/domains/data/models/domain_availability_model.dart';

abstract class DomainRepository {
  Future<List<DomainModel>> getDomains();
  Future<List<DomainAvailabilityModel>> checkDomainAvailability(
    List<String> domains,
  );
  Future<Map<String, dynamic>> getWhoisInfo(String domain);
}
