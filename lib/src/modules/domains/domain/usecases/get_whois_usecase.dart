import 'package:hpanelx/src/modules/domains/domain/repositories/domain_repository.dart';

class GetWhoisUseCase {
  final DomainRepository repository;

  GetWhoisUseCase({required this.repository});

  Future<Map<String, dynamic>> execute(String domain) async {
    return await repository.getWhoisInfo(domain);
  }
} 