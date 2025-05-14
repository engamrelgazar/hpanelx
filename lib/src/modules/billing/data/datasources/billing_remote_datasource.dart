import 'package:hpanelx/src/core/api/api_client.dart';
import 'package:hpanelx/src/modules/billing/data/models/subscription_model.dart';

abstract class BillingRemoteDataSource {
  Future<List<SubscriptionModel>> getSubscriptions();
}

class BillingRemoteDataSourceImpl implements BillingRemoteDataSource {
  final ApiClient apiClient;

  BillingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SubscriptionModel>> getSubscriptions() async {
    try {
      final response = await apiClient.get('/api/billing/v1/subscriptions');

      final List<dynamic> subscriptionsData = response as List<dynamic>;

      return subscriptionsData
          .map((data) => SubscriptionModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to load subscriptions from API: $e');
    }
  }
}
