import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hpanelx/src/core/error/failures.dart';
import 'package:hpanelx/src/modules/startup/domain/repositories/auth_repository.dart';

class SaveTokenUseCase {
  final AuthRepository repository;

  SaveTokenUseCase(this.repository);

  Future<Either<Failure, bool>> call(SaveTokenParams params) async {
    return await repository.saveToken(params.token);
  }
}

class SaveTokenParams extends Equatable {
  final String token;

  const SaveTokenParams({required this.token});

  @override
  List<Object?> get props => [token];
}
