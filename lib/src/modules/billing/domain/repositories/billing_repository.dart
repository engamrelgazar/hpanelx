import 'package:hpanelx/src/modules/billing/data/models/subscription_model.dart';
import 'package:hpanelx/src/modules/billing/data/models/payment_method_model.dart';

abstract class BillingRepository {
  Future<List<SubscriptionModel>> getSubscriptions();
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<void> deletePaymentMethod(int paymentMethodId);
  Future<void> setDefaultPaymentMethod(int paymentMethodId);
}
