import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hpanelx/src/modules/billing/data/models/payment_method_model.dart';
import 'package:hpanelx/src/modules/billing/domain/usecases/get_payment_methods_usecase.dart';
import 'package:hpanelx/src/modules/billing/domain/usecases/delete_payment_method_usecase.dart';
import 'package:hpanelx/src/modules/billing/domain/usecases/set_default_payment_method_usecase.dart';

abstract class PaymentMethodsState extends Equatable {
  const PaymentMethodsState();

  @override
  List<Object?> get props => [];
}

class PaymentMethodsInitial extends PaymentMethodsState {}

class PaymentMethodsLoading extends PaymentMethodsState {}

class PaymentMethodsLoaded extends PaymentMethodsState {
  final List<PaymentMethodModel> paymentMethods;

  const PaymentMethodsLoaded(this.paymentMethods);

  @override
  List<Object?> get props => [paymentMethods];
}

class PaymentMethodsError extends PaymentMethodsState {
  final String message;

  const PaymentMethodsError(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentMethodDeleting extends PaymentMethodsState {
  final int paymentMethodId;

  const PaymentMethodDeleting(this.paymentMethodId);

  @override
  List<Object?> get props => [paymentMethodId];
}

class PaymentMethodDeleted extends PaymentMethodsState {
  final int paymentMethodId;

  const PaymentMethodDeleted(this.paymentMethodId);

  @override
  List<Object?> get props => [paymentMethodId];
}

class PaymentMethodSettingDefault extends PaymentMethodsState {
  final int paymentMethodId;

  const PaymentMethodSettingDefault(this.paymentMethodId);

  @override
  List<Object?> get props => [paymentMethodId];
}

class PaymentMethodDefaultSet extends PaymentMethodsState {
  final int paymentMethodId;

  const PaymentMethodDefaultSet(this.paymentMethodId);

  @override
  List<Object?> get props => [paymentMethodId];
}

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  final GetPaymentMethodsUseCase getPaymentMethodsUseCase;
  final DeletePaymentMethodUseCase deletePaymentMethodUseCase;
  final SetDefaultPaymentMethodUseCase setDefaultPaymentMethodUseCase;

  PaymentMethodsCubit({
    required this.getPaymentMethodsUseCase,
    required this.deletePaymentMethodUseCase,
    required this.setDefaultPaymentMethodUseCase,
  }) : super(PaymentMethodsInitial());

  Future<void> getPaymentMethods() async {
    emit(PaymentMethodsLoading());

    try {
      final paymentMethods = await getPaymentMethodsUseCase.execute();
      emit(PaymentMethodsLoaded(paymentMethods));
    } catch (e) {
      emit(PaymentMethodsError(e.toString()));
    }
  }

  Future<void> deletePaymentMethod(int paymentMethodId) async {
    emit(PaymentMethodDeleting(paymentMethodId));

    try {
      await deletePaymentMethodUseCase.execute(paymentMethodId);
      emit(PaymentMethodDeleted(paymentMethodId));

      await getPaymentMethods();
    } catch (e) {
      emit(PaymentMethodsError(e.toString()));
    }
  }

  Future<void> setDefaultPaymentMethod(int paymentMethodId) async {
    emit(PaymentMethodSettingDefault(paymentMethodId));

    try {
      await setDefaultPaymentMethodUseCase.execute(paymentMethodId);
      emit(PaymentMethodDefaultSet(paymentMethodId));

      await getPaymentMethods();
    } catch (e) {
      emit(PaymentMethodsError(e.toString()));
    }
  }

  Future<void> refreshPaymentMethods() async {
    await getPaymentMethods();
  }
}
