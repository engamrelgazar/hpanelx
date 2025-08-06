part of 'domains_bloc.dart';

enum DomainAvailabilityStatus { initial, loading, loaded, error }

abstract class DomainsState extends Equatable {
  const DomainsState();

  @override
  List<Object?> get props => [];
}

class DomainsInitial extends DomainsState {}

class DomainsLoading extends DomainsState {}

class DomainsLoaded extends DomainsState {
  final List<DomainModel> domains;
  final DomainAvailabilityStatus availabilityStatus;
  final List<DomainAvailabilityModel>? availabilityResults;
  final String? availabilityError;

  const DomainsLoaded({
    required this.domains,
    this.availabilityStatus = DomainAvailabilityStatus.initial,
    this.availabilityResults,
    this.availabilityError,
  });

  @override
  List<Object?> get props =>
      [domains, availabilityStatus, availabilityResults, availabilityError];

  DomainsLoaded copyWith({
    List<DomainModel>? domains,
    DomainAvailabilityStatus? availabilityStatus,
    List<DomainAvailabilityModel>? availabilityResults,
    String? availabilityError,
  }) {
    return DomainsLoaded(
      domains: domains ?? this.domains,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      availabilityResults: availabilityResults ?? this.availabilityResults,
      availabilityError: availabilityError ?? this.availabilityError,
    );
  }
}

class DomainsError extends DomainsState {
  final String message;

  const DomainsError({required this.message});

  @override
  List<Object> get props => [message];
}

class DomainsSearchActive extends DomainsState {
  final String query;
  final List<DomainModel> filteredDomains;
  final List<DomainModel> allDomains;
  final DomainAvailabilityStatus availabilityStatus;
  final List<DomainAvailabilityModel>? availabilityResults;
  final String? availabilityError;

  const DomainsSearchActive({
    required this.query,
    required this.filteredDomains,
    required this.allDomains,
    this.availabilityStatus = DomainAvailabilityStatus.initial,
    this.availabilityResults,
    this.availabilityError,
  });

  @override
  List<Object?> get props => [
        query,
        filteredDomains,
        allDomains,
        availabilityStatus,
        availabilityResults,
        availabilityError
      ];

  DomainsSearchActive copyWith({
    String? query,
    List<DomainModel>? filteredDomains,
    List<DomainModel>? allDomains,
    DomainAvailabilityStatus? availabilityStatus,
    List<DomainAvailabilityModel>? availabilityResults,
    String? availabilityError,
  }) {
    return DomainsSearchActive(
      query: query ?? this.query,
      filteredDomains: filteredDomains ?? this.filteredDomains,
      allDomains: allDomains ?? this.allDomains,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      availabilityResults: availabilityResults ?? this.availabilityResults,
      availabilityError: availabilityError ?? this.availabilityError,
    );
  }
}
