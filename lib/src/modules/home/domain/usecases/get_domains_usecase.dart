import 'package:dartz/dartz.dart';
import 'package:hpanelx/src/core/error/failures.dart';
import 'package:hpanelx/src/modules/home/data/models/domain_model.dart';
import 'package:hpanelx/src/modules/home/domain/repositories/home_repository.dart';

class GetDomainsUseCase {
  final HomeRepository repository;

  GetDomainsUseCase(this.repository);

  Future<Either<Failure, List<DomainModel>>> call() async {
    return await repository.getDomains();
  }
}
