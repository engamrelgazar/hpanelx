import 'package:hpanelx/src/modules/billing/domain/repositories/billing_repository.dart';

class SetDefaultPaymentMethodUseCase {
  final BillingRepository repository;

  SetDefaultPaymentMethodUseCase({required this.repository});

  Future<void> execute(int paymentMethodId) async {
    return await repository.setDefaultPaymentMethod(paymentMethodId);
  }
}
