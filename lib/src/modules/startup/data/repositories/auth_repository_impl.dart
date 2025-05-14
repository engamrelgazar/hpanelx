import 'package:dartz/dartz.dart';
import 'package:hpanelx/src/core/error/exceptions.dart';
import 'package:hpanelx/src/core/error/failures.dart';
import 'package:hpanelx/src/modules/startup/data/datasources/auth_local_datasource.dart';
import 'package:hpanelx/src/modules/startup/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> saveToken(String token) async {
    try {
      await localDataSource.saveToken(token);
      return const Right(true);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> removeToken() async {
    try {
      await localDataSource.removeToken();
      return const Right(true);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
