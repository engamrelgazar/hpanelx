// Export the GetIt instance
export 'package:get_it/get_it.dart';
export 'injection_container.dart' show sl;

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hpanelx/src/core/routes/app_router.dart';
import 'package:hpanelx/src/core/theme/theme_cubit.dart';
import 'package:hpanelx/src/modules/startup/domain/repositories/auth_repository.dart';
import 'package:hpanelx/src/modules/startup/domain/usecases/check_token_usecase.dart';
import 'package:hpanelx/src/modules/startup/domain/usecases/remove_token_usecase.dart';
import 'package:hpanelx/src/modules/startup/domain/usecases/save_token_usecase.dart';
import 'package:hpanelx/src/modules/startup/data/repositories/auth_repository_impl.dart';
import 'package:hpanelx/src/modules/startup/data/datasources/auth_local_datasource.dart';
import 'package:hpanelx/src/modules/startup/presentation/bloc/startup_bloc.dart';

// Home module imports
import 'package:hpanelx/src/modules/home/data/datasources/home_remote_datasource.dart';
import 'package:hpanelx/src/modules/home/data/repositories/home_repository_impl.dart';
import 'package:hpanelx/src/modules/home/domain/repositories/home_repository.dart';
import 'package:hpanelx/src/modules/home/domain/usecases/get_domains_usecase.dart';
import 'package:hpanelx/src/modules/home/domain/usecases/get_servers_usecase.dart';
import 'package:hpanelx/src/modules/home/presentation/bloc/home_bloc.dart';

// Domains module imports
import 'package:hpanelx/src/modules/domains/data/repositories/domain_repository_impl.dart';
import 'package:hpanelx/src/modules/domains/domain/repositories/domain_repository.dart';
import 'package:hpanelx/src/modules/domains/domain/usecases/get_domains_usecase.dart'
    as domains;
import 'package:hpanelx/src/modules/domains/domain/usecases/check_domain_availability_usecase.dart';
import 'package:hpanelx/src/modules/domains/domain/usecases/get_whois_usecase.dart';
import 'package:hpanelx/src/modules/domains/presentation/bloc/domains_bloc.dart';
import 'package:hpanelx/src/modules/domains/presentation/cubit/domain_checker_cubit.dart';
import 'package:hpanelx/src/modules/domains/presentation/cubit/domain_checker_sheet_cubit.dart';
import 'package:hpanelx/src/modules/domains/presentation/cubit/domain_search_cubit.dart';

// Billing module imports
import 'package:hpanelx/src/modules/billing/data/datasources/billing_remote_datasource.dart';
import 'package:hpanelx/src/modules/billing/data/repositories/billing_repository_impl.dart';
import 'package:hpanelx/src/modules/billing/domain/repositories/billing_repository.dart';
import 'package:hpanelx/src/modules/billing/domain/usecases/get_subscriptions_usecase.dart';
import 'package:hpanelx/src/modules/billing/presentation/cubit/billing_cubit.dart';

import 'package:hpanelx/src/core/api/api_client.dart';

// VMs module imports
import 'package:hpanelx/src/modules/vms/data/datasources/vm_remote_datasource.dart';
import 'package:hpanelx/src/modules/vms/data/repositories/vm_repository_impl.dart';
import 'package:hpanelx/src/modules/vms/domain/repositories/vm_repository.dart';
import 'package:hpanelx/src/modules/vms/domain/usecases/get_virtual_machines_usecase.dart';
import 'package:hpanelx/src/modules/vms/domain/usecases/get_virtual_machine_by_id_usecase.dart';
import 'package:hpanelx/src/modules/vms/domain/usecases/vm_action_usecases.dart';
import 'package:hpanelx/src/modules/vms/presentation/cubit/vms_cubit.dart';

/// The Service Locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerSingleton<Dio>(Dio());

  // Core
  sl.registerSingleton<AppRouter>(AppRouterImpl());
  sl.registerSingleton<ApiClient>(ApiClient());

  // Theme
  sl.registerSingleton<ThemeCubit>(ThemeCubit(sl()));

  // Data sources
  sl.registerSingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl(sl()));
  sl.registerSingleton<HomeRemoteDataSource>(
    HomeRemoteDataSourceImpl(apiClient: sl()),
  );

  // Billing data source
  sl.registerSingleton<BillingRemoteDataSource>(
    BillingRemoteDataSourceImpl(apiClient: sl()),
  );

  // VMs data source
  sl.registerSingleton<VmRemoteDataSource>(
    VmRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repositories
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(localDataSource: sl()),
  );

  sl.registerSingleton<HomeRepository>(
    HomeRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerSingleton<DomainRepository>(DomainRepositoryImpl(apiClient: sl()));

  // Billing repository
  sl.registerSingleton<BillingRepository>(
    BillingRepositoryImpl(remoteDataSource: sl()),
  );

  // VMs repository
  sl.registerSingleton<VmRepository>(VmRepositoryImpl(remoteDataSource: sl()));

  // Use cases
  sl.registerSingleton<CheckTokenUseCase>(CheckTokenUseCase(sl()));
  sl.registerSingleton<SaveTokenUseCase>(SaveTokenUseCase(sl()));
  sl.registerSingleton<RemoveTokenUseCase>(RemoveTokenUseCase(sl()));

  sl.registerSingleton<GetServersUseCase>(GetServersUseCase(sl()));
  sl.registerSingleton<GetDomainsUseCase>(GetDomainsUseCase(sl()));

  sl.registerSingleton<domains.GetDomainsUseCase>(
    domains.GetDomainsUseCase(repository: sl()),
  );

  sl.registerSingleton<CheckDomainAvailabilityUseCase>(
    CheckDomainAvailabilityUseCase(repository: sl()),
  );

  // Register the WHOIS use case and cubit
  sl.registerSingleton<GetWhoisUseCase>(GetWhoisUseCase(repository: sl()));

  // Billing use case
  sl.registerSingleton<GetSubscriptionsUseCase>(
    GetSubscriptionsUseCase(repository: sl()),
  );

  // VMs use cases
  sl.registerSingleton<GetVirtualMachinesUseCase>(
    GetVirtualMachinesUseCase(repository: sl()),
  );

  sl.registerSingleton<GetVirtualMachineByIdUseCase>(
    GetVirtualMachineByIdUseCase(repository: sl()),
  );

  sl.registerSingleton<RebootVirtualMachineUseCase>(
    RebootVirtualMachineUseCase(repository: sl()),
  );

  sl.registerSingleton<ShutdownVirtualMachineUseCase>(
    ShutdownVirtualMachineUseCase(repository: sl()),
  );

  sl.registerSingleton<StartVirtualMachineUseCase>(
    StartVirtualMachineUseCase(repository: sl()),
  );

  // BLoCs
  sl.registerFactory<StartupBloc>(
    () => StartupBloc(
      checkTokenUseCase: sl(),
      saveTokenUseCase: sl(),
      removeTokenUseCase: sl(),
    ),
  );

  sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      getServersUseCase: sl(),
      getDomainsUseCase: sl(),
      checkTokenUseCase: sl(),
    ),
  );

  sl.registerFactory<DomainsBloc>(() => DomainsBloc(getDomainsUseCase: sl()));

  sl.registerFactory<DomainCheckerCubit>(
    () => DomainCheckerCubit(checkDomainAvailabilityUseCase: sl()),
  );

  // Register DomainCheckerSheetCubit
  sl.registerFactory<DomainCheckerSheetCubit>(() => DomainCheckerSheetCubit());

  // Register DomainSearchCubit
  sl.registerFactory<DomainSearchCubit>(() => DomainSearchCubit());

  // Billing cubit
  sl.registerFactory<BillingCubit>(
    () => BillingCubit(getSubscriptionsUseCase: sl()),
  );

  // VMs cubit
  sl.registerFactory<VmsCubit>(
    () => VmsCubit(
      getVirtualMachinesUseCase: sl(),
      getVirtualMachineByIdUseCase: sl(),
      rebootVirtualMachineUseCase: sl(),
      shutdownVirtualMachineUseCase: sl(),
      startVirtualMachineUseCase: sl(),
    ),
  );
}
