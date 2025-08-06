import 'package:hpanelx/src/modules/billing/data/datasources/billing_remote_datasource.dart';
import 'package:hpanelx/src/modules/billing/data/models/subscription_model.dart';
import 'package:hpanelx/src/modules/billing/data/models/payment_method_model.dart';
import 'package:hpanelx/src/modules/billing/domain/repositories/billing_repository.dart';

class BillingRepositoryImpl implements BillingRepository {
  final BillingRemoteDataSource remoteDataSource;

  BillingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SubscriptionModel>> getSubscriptions() async {
    try {
      return await remoteDataSource.getSubscriptions();
    } catch (e) {
      throw Exception('Failed to load subscriptions: $e');
    }
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      return await remoteDataSource.getPaymentMethods();
    } catch (e) {
      throw Exception('Failed to load payment methods: $e');
    }
  }

  @override
  Future<void> deletePaymentMethod(int paymentMethodId) async {
    try {
      await remoteDataSource.deletePaymentMethod(paymentMethodId);
    } catch (e) {
      throw Exception('Failed to delete payment method: $e');
    }
  }

  @override
  Future<void> setDefaultPaymentMethod(int paymentMethodId) async {
    try {
      await remoteDataSource.setDefaultPaymentMethod(paymentMethodId);
    } catch (e) {
      throw Exception('Failed to set default payment method: $e');
    }
  }
}
