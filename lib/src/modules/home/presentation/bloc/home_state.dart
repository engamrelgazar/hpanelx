part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ServerModel> servers;
  final List<DomainModel> domains;
  final int activeServersCount;
  final int activeDomainsCount;

  const HomeLoaded({
    required this.servers,
    required this.domains,
    required this.activeServersCount,
    required this.activeDomainsCount,
  });

  @override
  List<Object> get props => [
    servers,
    domains,
    activeServersCount,
    activeDomainsCount,
  ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}
