part of 'startup_bloc.dart';

abstract class StartupState extends Equatable {
  const StartupState();

  @override
  List<Object> get props => [];
}

class StartupInitial extends StartupState {}

class StartupLoading extends StartupState {}

class TokenAvailable extends StartupState {
  final String token;

  const TokenAvailable({required this.token});

  @override
  List<Object> get props => [token];
}

class TokenNotAvailable extends StartupState {}

class TokenSaved extends StartupState {
  final String token;

  const TokenSaved({required this.token});

  @override
  List<Object> get props => [token];
}

class StartupError extends StartupState {
  final String message;

  const StartupError({required this.message});

  @override
  List<Object> get props => [message];
}

class TokenVisibilityState extends StartupState {
  final bool isVisible;

  const TokenVisibilityState(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}

class LogoutSuccess extends StartupState {}

class TokenValidated extends StartupState {
  final bool isValid;

  const TokenValidated({required this.isValid});

  @override
  List<Object> get props => [isValid];
}
