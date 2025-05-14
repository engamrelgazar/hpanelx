import 'package:hpanelx/src/modules/billing/data/models/subscription_model.dart';

abstract class BillingRepository {
  Future<List<SubscriptionModel>> getSubscriptions();
} 