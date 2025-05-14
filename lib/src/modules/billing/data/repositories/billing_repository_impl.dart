import 'package:hpanelx/src/modules/billing/data/datasources/billing_remote_datasource.dart';
import 'package:hpanelx/src/modules/billing/data/models/subscription_model.dart';
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
}
