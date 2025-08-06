part of 'domains_bloc.dart';

abstract class DomainsEvent extends Equatable {
  const DomainsEvent();

  @override
  List<Object> get props => [];
}

class LoadDomainsEvent extends DomainsEvent {}

class SearchDomainsEvent extends DomainsEvent {
  final String query;
  final List<DomainModel> allDomains;

  const SearchDomainsEvent({required this.query, required this.allDomains});

  @override
  List<Object> get props => [query, allDomains];
}

class ClearSearchEvent extends DomainsEvent {}

class CheckDomainAvailabilityEvent extends DomainsEvent {
  final List<String> domains;

  const CheckDomainAvailabilityEvent({required this.domains});

  @override
  List<Object> get props => [domains];
} 