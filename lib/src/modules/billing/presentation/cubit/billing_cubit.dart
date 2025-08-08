import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hpanelx/src/modules/billing/data/models/subscription_model.dart';
import 'package:hpanelx/src/modules/billing/domain/usecases/get_subscriptions_usecase.dart';

abstract class BillingState extends Equatable {
  const BillingState();

  @override
  List<Object?> get props => [];
}

class BillingInitial extends BillingState {}

class BillingLoading extends BillingState {}

class BillingLoaded extends BillingState {
  final List<SubscriptionModel> subscriptions;

  const BillingLoaded(this.subscriptions);

  @override
  List<Object?> get props => [subscriptions];
}

class BillingError extends BillingState {
  final String message;

  const BillingError(this.message);

  @override
  List<Object?> get props => [message];
}

class BillingCubit extends Cubit<BillingState> {
  final GetSubscriptionsUseCase getSubscriptionsUseCase;

  BillingCubit({required this.getSubscriptionsUseCase})
      : super(BillingInitial());

  Future<void> getSubscriptions() async {
    emit(BillingLoading());

    try {
      final subscriptions = await getSubscriptionsUseCase.execute();
      emit(BillingLoaded(subscriptions));
    } catch (e) {
      emit(BillingError(e.toString()));
    }
  }
}
