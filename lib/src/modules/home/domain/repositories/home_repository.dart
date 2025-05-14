import 'package:dartz/dartz.dart';
import 'package:hpanelx/src/core/error/failures.dart';
import 'package:hpanelx/src/modules/home/data/models/domain_model.dart';
import 'package:hpanelx/src/modules/home/data/models/server_model.dart';

abstract class HomeRepository {
  /// Gets the list of servers from the API
  Future<Either<Failure, List<ServerModel>>> getServers();

  /// Gets the list of domains from the API
  Future<Either<Failure, List<DomainModel>>> getDomains();
}
