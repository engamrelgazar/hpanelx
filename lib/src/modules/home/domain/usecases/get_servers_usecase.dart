import 'package:dartz/dartz.dart';
import 'package:hpanelx/src/core/error/failures.dart';
import 'package:hpanelx/src/modules/home/data/models/server_model.dart';
import 'package:hpanelx/src/modules/home/domain/repositories/home_repository.dart';

class GetServersUseCase {
  final HomeRepository repository;

  GetServersUseCase(this.repository);

  Future<Either<Failure, List<ServerModel>>> call() async {
    return await repository.getServers();
  }
} 