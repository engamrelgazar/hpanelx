import 'package:hpanelx/src/modules/domains/data/models/domain_model.dart';
import 'package:hpanelx/src/modules/domains/domain/repositories/domain_repository.dart';

class GetDomainsUseCase {
  final DomainRepository repository;

  GetDomainsUseCase({required this.repository});

  Future<List<DomainModel>> execute() async {
    return await repository.getDomains();
  }
}
