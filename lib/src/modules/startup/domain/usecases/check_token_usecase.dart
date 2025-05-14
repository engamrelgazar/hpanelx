import 'package:dartz/dartz.dart';
import 'package:hpanelx/src/core/error/failures.dart';
import 'package:hpanelx/src/modules/startup/domain/repositories/auth_repository.dart';

class CheckTokenUseCase {
  final AuthRepository repository;

  CheckTokenUseCase(this.repository);

  Future<Either<Failure, String?>> call() async {
    return await repository.getToken();
  }
}
