import 'package:hpanelx/src/modules/billing/data/models/subscription_model.dart';
import 'package:hpanelx/src/modules/billing/domain/repositories/billing_repository.dart';

class GetSubscriptionsUseCase {
  final BillingRepository repository;

  GetSubscriptionsUseCase({required this.repository});

  Future<List<SubscriptionModel>> execute() async {
    return await repository.getSubscriptions();
  }
}
