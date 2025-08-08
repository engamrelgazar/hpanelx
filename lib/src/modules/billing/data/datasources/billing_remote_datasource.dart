import 'package:hpanelx/src/core/api/api_client.dart';
import 'package:hpanelx/src/modules/billing/data/models/subscription_model.dart';
import 'package:hpanelx/src/modules/billing/data/models/payment_method_model.dart';

abstract class BillingRemoteDataSource {
  Future<List<SubscriptionModel>> getSubscriptions();
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<void> deletePaymentMethod(int paymentMethodId);
  Future<void> setDefaultPaymentMethod(int paymentMethodId);
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

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      final response = await apiClient.get('/api/billing/v1/payment-methods');

      final List<dynamic> paymentMethodsData = response as List<dynamic>;

      return paymentMethodsData
          .map((data) => PaymentMethodModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to load payment methods from API: $e');
    }
  }

  @override
  Future<void> deletePaymentMethod(int paymentMethodId) async {
    try {
      await apiClient
          .delete('/api/billing/v1/payment-methods/$paymentMethodId');
    } catch (e) {
      throw Exception('Failed to delete payment method: $e');
    }
  }

  @override
  Future<void> setDefaultPaymentMethod(int paymentMethodId) async {
    try {
      await apiClient.post(
        '/api/billing/v1/payment-methods/$paymentMethodId',
        data: {
          'is_default': true,
        },
      );
    } catch (e) {
      throw Exception('Failed to set default payment method: $e');
    }
  }
}
