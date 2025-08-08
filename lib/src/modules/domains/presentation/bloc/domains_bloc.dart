import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hpanelx/src/modules/domains/data/models/domain_model.dart';
import 'package:hpanelx/src/modules/domains/data/models/domain_availability_model.dart';
import 'package:hpanelx/src/modules/domains/domain/usecases/get_domains_usecase.dart';
import 'package:hpanelx/src/modules/domains/domain/usecases/check_domain_availability_usecase.dart';

part 'domains_event.dart';
part 'domains_state.dart';

class DomainsBloc extends Bloc<DomainsEvent, DomainsState> {
  final GetDomainsUseCase getDomainsUseCase;
  final CheckDomainAvailabilityUseCase checkDomainAvailabilityUseCase;

  DomainsBloc({
    required this.getDomainsUseCase,
    required this.checkDomainAvailabilityUseCase,
  }) : super(DomainsInitial()) {
    on<LoadDomainsEvent>(_onLoadDomains);
    on<SearchDomainsEvent>(_onSearchDomains);
    on<ClearSearchEvent>(_onClearSearch);
    on<CheckDomainAvailabilityEvent>(_onCheckDomainAvailability);
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

  void _onSearchDomains(
    SearchDomainsEvent event,
    Emitter<DomainsState> emit,
  ) {
    final currentState = state;
    DomainAvailabilityStatus availabilityStatus =
        DomainAvailabilityStatus.initial;
    List<DomainAvailabilityModel>? availabilityResults;
    String? availabilityError;

    if (currentState is DomainsLoaded) {
      availabilityStatus = currentState.availabilityStatus;
      availabilityResults = currentState.availabilityResults;
      availabilityError = currentState.availabilityError;
    } else if (currentState is DomainsSearchActive) {
      availabilityStatus = currentState.availabilityStatus;
      availabilityResults = currentState.availabilityResults;
      availabilityError = currentState.availabilityError;
    }

    if (event.query.isEmpty) {
      emit(DomainsLoaded(
        domains: event.allDomains,
        availabilityStatus: availabilityStatus,
        availabilityResults: availabilityResults,
        availabilityError: availabilityError,
      ));
    } else {
      final filteredDomains = event.allDomains
          .where((domain) =>
              domain.domain.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(DomainsSearchActive(
        query: event.query,
        filteredDomains: filteredDomains,
        allDomains: event.allDomains,
        availabilityStatus: availabilityStatus,
        availabilityResults: availabilityResults,
        availabilityError: availabilityError,
      ));
    }
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<DomainsState> emit,
  ) {
    if (state is DomainsSearchActive) {
      final searchState = state as DomainsSearchActive;
      emit(DomainsLoaded(
        domains: searchState.allDomains,
        availabilityStatus: searchState.availabilityStatus,
        availabilityResults: searchState.availabilityResults,
        availabilityError: searchState.availabilityError,
      ));
    }
  }

  Future<void> _onCheckDomainAvailability(
    CheckDomainAvailabilityEvent event,
    Emitter<DomainsState> emit,
  ) async {
    final currentState = state;

    if (currentState is DomainsLoaded) {
      emit(currentState.copyWith(
        availabilityStatus: DomainAvailabilityStatus.loading,
        availabilityResults: null,
        availabilityError: null,
      ));
    } else if (currentState is DomainsSearchActive) {
      emit(currentState.copyWith(
        availabilityStatus: DomainAvailabilityStatus.loading,
        availabilityResults: null,
        availabilityError: null,
      ));
    }

    try {
      final results =
          await checkDomainAvailabilityUseCase.execute(event.domains);

      final updatedState = state;
      if (updatedState is DomainsLoaded) {
        emit(updatedState.copyWith(
          availabilityStatus: DomainAvailabilityStatus.loaded,
          availabilityResults: results,
        ));
      } else if (updatedState is DomainsSearchActive) {
        emit(updatedState.copyWith(
          availabilityStatus: DomainAvailabilityStatus.loaded,
          availabilityResults: results,
        ));
      }
    } catch (e) {
      final updatedState = state;
      if (updatedState is DomainsLoaded) {
        emit(updatedState.copyWith(
          availabilityStatus: DomainAvailabilityStatus.error,
          availabilityError: e.toString(),
        ));
      } else if (updatedState is DomainsSearchActive) {
        emit(updatedState.copyWith(
          availabilityStatus: DomainAvailabilityStatus.error,
          availabilityError: e.toString(),
        ));
      }
    }
  }
}
