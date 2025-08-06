import 'package:dartz/dartz.dart';
import 'package:hpanelx/src/core/error/failures.dart';
import 'package:hpanelx/src/modules/startup/domain/repositories/auth_repository.dart';

class ValidateTokenUseCase {
  final AuthRepository repository;

  ValidateTokenUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.validateToken();
  }
}
