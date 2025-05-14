import 'package:hpanelx/src/modules/domains/data/models/domain_availability_model.dart';
import 'package:hpanelx/src/modules/domains/domain/repositories/domain_repository.dart';

class CheckDomainAvailabilityUseCase {
  final DomainRepository repository;

  CheckDomainAvailabilityUseCase({required this.repository});

  Future<List<DomainAvailabilityModel>> execute(List<String> domains) async {
    return await repository.checkDomainAvailability(domains);
  }
}
