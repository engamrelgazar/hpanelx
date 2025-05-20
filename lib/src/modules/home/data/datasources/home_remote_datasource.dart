import 'package:hpanelx/src/core/api/api_client.dart';
import 'package:hpanelx/src/core/api/api_constants.dart';
import 'package:hpanelx/src/core/error/exceptions.dart';
import 'package:hpanelx/src/modules/home/data/models/domain_model.dart';
import 'package:hpanelx/src/modules/home/data/models/server_model.dart';

abstract class HomeRemoteDataSource {
  /// Fetches all servers from the API
  /// Throws a [ServerException] for all error codes
  Future<List<ServerModel>> getServers();

  /// Fetches all domains from the API
  /// Throws a [ServerException] for all error codes
  Future<List<DomainModel>> getDomains();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ServerModel>> getServers() async {
    try {
      final response = await apiClient.get(ApiConstants.serversEndpoint);

      if (response != null) {
        final List<dynamic> serverData = response;
        return serverData.map((json) => ServerModel.fromJson(json)).toList();
      } else {
        throw ServerException(
        'Failed to load servers: No data returned',
        );
      }
    } catch (e) {
      throw ServerException('Failed to load servers: $e');
    }
  }

  @override
  Future<List<DomainModel>> getDomains() async {
    try {
      final response = await apiClient.get(ApiConstants.domainsEndpoint);

      if (response != null) {
        final List<dynamic> domainData = response;
        return domainData.map((json) => DomainModel.fromJson(json)).toList();
      } else {
        throw ServerException(
       'Failed to load domains: No data returned',
        );
      }
    } catch (e) {
      throw ServerException( 'Failed to load domains: $e');
    }
  }
}
