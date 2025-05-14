import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hpanelx/src/modules/domains/domain/usecases/check_domain_availability_usecase.dart';
import 'package:hpanelx/src/modules/domains/data/models/domain_availability_model.dart';

// States
abstract class DomainCheckerState extends Equatable {
  const DomainCheckerState();

  @override
  List<Object?> get props => [];
}

class DomainCheckerInitial extends DomainCheckerState {}

class DomainCheckerLoading extends DomainCheckerState {}

class DomainCheckerLoaded extends DomainCheckerState {
  final List<DomainAvailabilityModel> results;

  const DomainCheckerLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class DomainCheckerError extends DomainCheckerState {
  final String message;

  const DomainCheckerError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class DomainCheckerCubit extends Cubit<DomainCheckerState> {
  final CheckDomainAvailabilityUseCase checkDomainAvailabilityUseCase;

  DomainCheckerCubit({required this.checkDomainAvailabilityUseCase})
    : super(DomainCheckerInitial());

  Future<void> checkDomainAvailability(List<String> domains) async {
    emit(DomainCheckerLoading());

    try {
      final results = await checkDomainAvailabilityUseCase.execute(domains);
      emit(DomainCheckerLoaded(results));
    } catch (e) {
      emit(DomainCheckerError(e.toString()));
    }
  }
}
