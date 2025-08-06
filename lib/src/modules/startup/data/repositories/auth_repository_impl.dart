import 'package:dartz/dartz.dart';
import 'package:hpanelx/src/core/error/exceptions.dart';
import 'package:hpanelx/src/core/error/failures.dart';
import 'package:hpanelx/src/modules/startup/data/datasources/auth_local_datasource.dart';
import 'package:hpanelx/src/modules/startup/domain/repositories/auth_repository.dart';
import 'package:hpanelx/src/core/api/api_client.dart';
import 'package:hpanelx/src/core/api/api_constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final ApiClient apiClient;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.apiClient,
  });

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

      apiClient.updateToken(token);
      return const Right(true);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> removeToken() async {
    try {
      await localDataSource.removeToken();

      apiClient.clearToken();
      return const Right(true);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> validateToken() async {
    try {

      await apiClient.post(
        ApiConstants.domainAvailabilityEndpoint,
        data: {
          "domain": "test",
          "tlds": ["com"],
          "with_alternatives": false,
        },
      );

      
      return const Right(true);
    } on UnauthorizedException catch (e) {
      
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(ConnectionFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Token validation failed: $e'));
    }
  }
}
