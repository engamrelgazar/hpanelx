import 'package:hpanelx/src/modules/billing/data/models/payment_method_model.dart';
import 'package:hpanelx/src/modules/billing/domain/repositories/billing_repository.dart';

class GetPaymentMethodsUseCase {
  final BillingRepository repository;

  GetPaymentMethodsUseCase({required this.repository});

  Future<List<PaymentMethodModel>> execute() async {
    return await repository.getPaymentMethods();
  }
}
