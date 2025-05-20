import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hpanelx/src/modules/home/data/models/domain_model.dart';
import 'package:hpanelx/src/modules/home/data/models/server_model.dart';
import 'package:hpanelx/src/modules/home/domain/usecases/get_domains_usecase.dart';
import 'package:hpanelx/src/modules/home/domain/usecases/get_servers_usecase.dart';
import 'package:hpanelx/src/modules/startup/domain/usecases/check_token_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetServersUseCase getServersUseCase;
  final GetDomainsUseCase getDomainsUseCase;
  final CheckTokenUseCase checkTokenUseCase;

  HomeBloc({
    required this.getServersUseCase,
    required this.getDomainsUseCase,
    required this.checkTokenUseCase,
  }) : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    // Get token first
    final tokenResult = await checkTokenUseCase();

    await tokenResult.fold(
      (failure) {
        emit(HomeError(message: 'Authentication error: ${failure.message}'));
      },
      (token) async {
        if (token == null || token.isEmpty) {
          emit(const HomeError(message: 'No authentication token found'));
          return;
        }

        // Load servers and domains in parallel
        final serversResult = await getServersUseCase();
        final domainsResult = await getDomainsUseCase();

        // Check if both succeeded
        if (serversResult.isRight() && domainsResult.isRight()) {
          final servers = serversResult.getOrElse(() => []);
          final domains = domainsResult.getOrElse(() => []);

          emit(
            HomeLoaded(
              servers: servers,
              domains: domains,
              activeServersCount: servers.where((s) => s.isActive).length,
              activeDomainsCount: domains.where((d) => d.isActive).length,
            ),
          );
        } else {
          // Extract error message from either result
          String errorMessage = '';
          serversResult.fold(
            (failure) => errorMessage = 'Server error: ${failure.message}',
            (_) => null,
          );
          if (errorMessage.isEmpty) {
            domainsResult.fold(
              (failure) => errorMessage = 'Domain error: ${failure.message}',
              (_) => null,
            );
          }
          emit(HomeError(message: errorMessage));
        }
      },
    );
  }
}
