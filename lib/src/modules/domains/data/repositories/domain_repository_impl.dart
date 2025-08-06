import 'package:hpanelx/src/core/api/api_client.dart';
import 'package:hpanelx/src/core/api/api_constants.dart';
import 'package:hpanelx/src/modules/domains/data/models/domain_model.dart';
import 'package:hpanelx/src/modules/domains/data/models/domain_availability_model.dart';
import 'package:hpanelx/src/modules/domains/domain/repositories/domain_repository.dart';

class DomainRepositoryImpl implements DomainRepository {
  final ApiClient apiClient;

  DomainRepositoryImpl({required this.apiClient});

  @override
  Future<List<DomainModel>> getDomains() async {
    try {
      final response = await apiClient.get(ApiConstants.domainsEndpoint);

      if (response != null) {
        final List<dynamic> domainsJson = response;
        return domainsJson.map((json) => DomainModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load domains: No data returned');
      }
    } catch (e) {
      throw Exception('Failed to load domains: $e');
    }
  }

  @override
  Future<List<DomainAvailabilityModel>> checkDomainAvailability(
    List<String> domains,
  ) async {
    try {
      String? baseDomain;
      List<String> tlds = [];

      for (String domain in domains) {
        if (domain.contains('.')) {
          int dotIndex = domain.indexOf('.');

          baseDomain ??= domain.substring(0, dotIndex);

          String tld = domain.substring(dotIndex + 1);
          tlds.add(tld);
        }
      }

      if (baseDomain == null || baseDomain.isEmpty || tlds.isEmpty) {
        throw Exception('Invalid domain name or TLDs');
      }

      final Map<String, dynamic> requestData = {
        "domain": baseDomain,
        "tlds": tlds,
        "with_alternatives": false,
      };

      final response = await apiClient.post(
        ApiConstants.domainAvailabilityEndpoint,
        data: requestData,
      );

      List<DomainAvailabilityModel> results = [];

      if (response is List) {
        for (var item in response) {
          if (item is Map<String, dynamic>) {
            results.add(DomainAvailabilityModel.fromJson(item));
          }
        }
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('results') && response['results'] is List) {
          final List resultsList = response['results'] as List;
          for (var item in resultsList) {
            if (item is Map<String, dynamic>) {
              results.add(DomainAvailabilityModel.fromJson(item));
            }
          }
        } else {
          results.add(DomainAvailabilityModel.fromJson(response));
        }
      }

      if (results.isEmpty) {
        throw Exception(
          'No valid domain availability results found in the response',
        );
      }

      return results;
    } catch (e) {
      throw Exception('Failed to check domain availability: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getWhoisInfo(String domain) async {
    try {
      final response = await apiClient.get(
        ApiConstants.whoisEndpoint,
        queryParameters: {'domain': domain},
      );

      if (response != null) {
        return response;
      } else {
        throw Exception('Failed to get WHOIS information: No data returned');
      }
    } catch (e) {
      throw Exception('Failed to get WHOIS information: $e');
    }
  }
}
