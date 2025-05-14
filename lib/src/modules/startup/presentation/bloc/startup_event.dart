part of 'startup_bloc.dart';

abstract class StartupEvent extends Equatable {
  const StartupEvent();

  @override
  List<Object> get props => [];
}

class CheckTokenEvent extends StartupEvent {}

class SaveTokenEvent extends StartupEvent {
  final String token;

  const SaveTokenEvent({required this.token});

  @override
  List<Object> get props => [token];
}

class ToggleTokenVisibilityEvent extends StartupEvent {}

class LogoutEvent extends StartupEvent {}
