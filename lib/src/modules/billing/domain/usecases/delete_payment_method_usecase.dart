import 'package:hpanelx/src/modules/billing/domain/repositories/billing_repository.dart';

class DeletePaymentMethodUseCase {
  final BillingRepository repository;

  DeletePaymentMethodUseCase({required this.repository});

  Future<void> execute(int paymentMethodId) async {
    return await repository.deletePaymentMethod(paymentMethodId);
  }
}
