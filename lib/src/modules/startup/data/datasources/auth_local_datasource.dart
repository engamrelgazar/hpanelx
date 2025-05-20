import 'package:shared_preferences/shared_preferences.dart';
import 'package:hpanelx/src/core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  /// Gets the cached token
  /// Throws [CacheException] if no token is present
  Future<String?> getToken();

  /// Saves the token
  /// Throws [CacheException] if saving fails
  Future<void> saveToken(String token);

  /// Removes the token
  /// Throws [CacheException] if removal fails
  Future<void> removeToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  static const tokenKey = 'BEARER_TOKEN';

  @override
  Future<String?> getToken() async {
    final token = sharedPreferences.getString(tokenKey);
    return token;
  }

  @override
  Future<void> saveToken(String token) async {
    final success = await sharedPreferences.setString(tokenKey, token);
    if (!success) {
      throw CacheException('Failed to save token');
    }
  }

  @override
  Future<void> removeToken() async {
    final success = await sharedPreferences.remove(tokenKey);
    if (!success) {
      throw CacheException( 'Failed to remove token');
    }
  }
}
