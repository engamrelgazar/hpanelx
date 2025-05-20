import 'package:dartz/dartz.dart';
import 'package:hpanelx/src/core/error/exceptions.dart';
import 'package:hpanelx/src/core/error/failures.dart';
import 'package:hpanelx/src/modules/home/data/datasources/home_remote_datasource.dart';
import 'package:hpanelx/src/modules/home/data/models/domain_model.dart';
import 'package:hpanelx/src/modules/home/data/models/server_model.dart';
import 'package:hpanelx/src/modules/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ServerModel>>> getServers() async {
    try {
      final servers = await remoteDataSource.getServers();
      return Right(servers);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DomainModel>>> getDomains() async {
    try {
      final domains = await remoteDataSource.getDomains();
      return Right(domains);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
