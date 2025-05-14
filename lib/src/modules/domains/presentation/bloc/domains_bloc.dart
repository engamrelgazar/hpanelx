import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/modules/domains/data/models/domain_model.dart';
import 'package:hpanelx/src/modules/domains/domain/usecases/get_domains_usecase.dart';

// Events
abstract class DomainsEvent {}

class LoadDomainsEvent extends DomainsEvent {}

// States
abstract class DomainsState {}

class DomainsInitial extends DomainsState {}

class DomainsLoading extends DomainsState {}

class DomainsLoaded extends DomainsState {
  final List<DomainModel> domains;

  DomainsLoaded({required this.domains});
}

class DomainsError extends DomainsState {
  final String message;

  DomainsError({required this.message});
}

// BLoC
class DomainsBloc extends Bloc<DomainsEvent, DomainsState> {
  final GetDomainsUseCase getDomainsUseCase;

  DomainsBloc({required this.getDomainsUseCase}) : super(DomainsInitial()) {
    on<LoadDomainsEvent>(_onLoadDomains);
  }

  Future<void> _onLoadDomains(
    LoadDomainsEvent event,
    Emitter<DomainsState> emit,
  ) async {
    emit(DomainsLoading());
    try {
      final domains = await getDomainsUseCase.execute();
      emit(DomainsLoaded(domains: domains));
    } catch (e) {
      emit(DomainsError(message: e.toString()));
    }
  }
}
