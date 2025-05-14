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
      // بما أن واجهة المستخدم تمنع إدخال النقطة والامتدادات
      // نتوقع أن تتلقى domains قائمة من النطاقات مع امتداداتها بالشكل: example.com، example.net، إلخ

      // استخراج اسم النطاق والامتدادات
      String? baseDomain;
      List<String> tlds = [];

      // نفترض أن كل النطاقات لها نفس الاسم الأساسي ولكن بامتدادات مختلفة
      for (String domain in domains) {
        if (domain.contains('.')) {
          int dotIndex = domain.indexOf('.');
          // تخزين اسم النطاق الأساسي (مثل: example)
          baseDomain ??= domain.substring(0, dotIndex);

          // تخزين الامتداد (مثل: com, net، إلخ)
          String tld = domain.substring(dotIndex + 1);
          tlds.add(tld);
        }
      }

      // التحقق من صحة البيانات
      if (baseDomain == null || baseDomain.isEmpty || tlds.isEmpty) {
        throw Exception('Invalid domain name or TLDs');
      }

      // إنشاء البيانات المطلوبة للـ API
      final Map<String, dynamic> requestData = {
        "domain": baseDomain,
        "tlds": tlds,
        "with_alternatives": false,
      };

      // استبدال print بـ log أو تعليق للمساعدة في التصحيح
      // logger.d("Sending data to API: $requestData");

      final response = await apiClient.post(
        ApiConstants.domainAvailabilityEndpoint,
        data: requestData,
      );

      // logger.d("API Response type: ${response.runtimeType}");
      // logger.d("API Response: $response");

      List<DomainAvailabilityModel> results = [];

      if (response is List) {
        // التعامل مع الاستجابة كقائمة
        for (var item in response) {
          if (item is Map<String, dynamic>) {
            results.add(DomainAvailabilityModel.fromJson(item));
          }
        }
      } else if (response is Map<String, dynamic>) {
        // التعامل مع الاستجابة كـ Map
        if (response.containsKey('results') && response['results'] is List) {
          // التعامل مع حالة وجود مفتاح 'results' يحتوي على قائمة النتائج
          final List resultsList = response['results'] as List;
          for (var item in resultsList) {
            if (item is Map<String, dynamic>) {
              results.add(DomainAvailabilityModel.fromJson(item));
            }
          }
        } else {
          // التعامل مع الاستجابة كنتيجة واحدة
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
