import 'package:dartz/dartz.dart';
import 'package:hpanelx/src/core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String?>> getToken();
  Future<Either<Failure, bool>> saveToken(String token);
  Future<Either<Failure, bool>> removeToken();
}
