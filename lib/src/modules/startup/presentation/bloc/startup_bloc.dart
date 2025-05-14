import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hpanelx/src/modules/startup/domain/usecases/check_token_usecase.dart';
import 'package:hpanelx/src/modules/startup/domain/usecases/remove_token_usecase.dart';
import 'package:hpanelx/src/modules/startup/domain/usecases/save_token_usecase.dart';

part 'startup_event.dart';
part 'startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  final CheckTokenUseCase checkTokenUseCase;
  final SaveTokenUseCase saveTokenUseCase;
  final RemoveTokenUseCase removeTokenUseCase;
  bool _isTokenVisible = false;

  StartupBloc({
    required this.checkTokenUseCase,
    required this.saveTokenUseCase,
    required this.removeTokenUseCase,
  }) : super(StartupInitial()) {
    on<CheckTokenEvent>(_onCheckToken);
    on<SaveTokenEvent>(_onSaveToken);
    on<ToggleTokenVisibilityEvent>(_onToggleTokenVisibility);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckToken(
    CheckTokenEvent event,
    Emitter<StartupState> emit,
  ) async {
    emit(StartupLoading());

    final result = await checkTokenUseCase();

    result.fold((failure) => emit(StartupError(message: failure.message)), (
      token,
    ) {
      if (token != null && token.isNotEmpty) {
        emit(TokenAvailable(token: token));
      } else {
        emit(TokenNotAvailable());
      }
    });
  }

  Future<void> _onSaveToken(
    SaveTokenEvent event,
    Emitter<StartupState> emit,
  ) async {
    emit(StartupLoading());

    final result = await saveTokenUseCase(SaveTokenParams(token: event.token));

    result.fold(
      (failure) => emit(StartupError(message: failure.message)),
      (_) => emit(TokenSaved(token: event.token)),
    );
  }

  void _onToggleTokenVisibility(
    ToggleTokenVisibilityEvent event,
    Emitter<StartupState> emit,
  ) {
    _isTokenVisible = !_isTokenVisible;
    emit(TokenVisibilityState(_isTokenVisible));
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<StartupState> emit) async {
    emit(StartupLoading());

    final result = await removeTokenUseCase();

    result.fold(
      (failure) => emit(StartupError(message: failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }
}
