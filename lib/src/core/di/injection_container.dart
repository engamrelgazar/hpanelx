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
import 'package:hpanelx/src/modules/startup/domain/usecases/validate_token_usecase.dart';
import 'package:hpanelx/src/modules/startup/data/repositories/auth_repository_impl.dart';
import 'package:hpanelx/src/modules/startup/data/datasources/auth_local_datasource.dart';
import 'package:hpanelx/src/modules/startup/presentation/bloc/startup_bloc.dart';

import 'package:hpanelx/src/modules/home/data/datasources/home_remote_datasource.dart';
import 'package:hpanelx/src/modules/home/data/repositories/home_repository_impl.dart';
import 'package:hpanelx/src/modules/home/domain/repositories/home_repository.dart';
import 'package:hpanelx/src/modules/home/domain/usecases/get_domains_usecase.dart';
import 'package:hpanelx/src/modules/home/domain/usecases/get_servers_usecase.dart';
import 'package:hpanelx/src/modules/home/presentation/bloc/home_bloc.dart';

import 'package:hpanelx/src/modules/domains/data/repositories/domain_repository_impl.dart';
import 'package:hpanelx/src/modules/domains/domain/repositories/domain_repository.dart';
import 'package:hpanelx/src/modules/domains/domain/usecases/get_domains_usecase.dart'
    as domains;
import 'package:hpanelx/src/modules/domains/domain/usecases/check_domain_availability_usecase.dart';
import 'package:hpanelx/src/modules/domains/domain/usecases/get_whois_usecase.dart';
import 'package:hpanelx/src/modules/domains/presentation/bloc/domains_bloc.dart';

import 'package:hpanelx/src/modules/billing/data/datasources/billing_remote_datasource.dart';
import 'package:hpanelx/src/modules/billing/data/repositories/billing_repository_impl.dart';
import 'package:hpanelx/src/modules/billing/domain/repositories/billing_repository.dart';
import 'package:hpanelx/src/modules/billing/domain/usecases/get_subscriptions_usecase.dart';
import 'package:hpanelx/src/modules/billing/domain/usecases/get_payment_methods_usecase.dart';
import 'package:hpanelx/src/modules/billing/domain/usecases/delete_payment_method_usecase.dart';
import 'package:hpanelx/src/modules/billing/domain/usecases/set_default_payment_method_usecase.dart';
import 'package:hpanelx/src/modules/billing/presentation/cubit/billing_cubit.dart';
import 'package:hpanelx/src/modules/billing/presentation/cubit/payment_methods_cubit.dart';

import 'package:hpanelx/src/core/api/api_client.dart';

import 'package:hpanelx/src/modules/vms/data/datasources/vm_remote_datasource.dart';
import 'package:hpanelx/src/modules/vms/data/repositories/vm_repository_impl.dart';
import 'package:hpanelx/src/modules/vms/domain/repositories/vm_repository.dart';
import 'package:hpanelx/src/modules/vms/domain/usecases/get_virtual_machines_usecase.dart';
import 'package:hpanelx/src/modules/vms/domain/usecases/get_virtual_machine_by_id_usecase.dart';
import 'package:hpanelx/src/modules/vms/domain/usecases/vm_action_usecases.dart';
import 'package:hpanelx/src/modules/vms/presentation/cubit/vms_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerSingleton<Dio>(Dio());

  sl.registerSingleton<AppRouter>(AppRouterImpl());
  sl.registerSingleton<ApiClient>(ApiClient(sharedPreferences: sl()));

  sl.registerSingleton<ThemeCubit>(ThemeCubit(sl()));

  sl.registerSingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl(sl()));
  sl.registerSingleton<HomeRemoteDataSource>(
    HomeRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerSingleton<BillingRemoteDataSource>(
    BillingRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerSingleton<VmRemoteDataSource>(
    VmRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      localDataSource: sl(),
      apiClient: sl(),
    ),
  );

  sl.registerSingleton<HomeRepository>(
    HomeRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerSingleton<DomainRepository>(DomainRepositoryImpl(apiClient: sl()));

  sl.registerSingleton<BillingRepository>(
    BillingRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerSingleton<VmRepository>(VmRepositoryImpl(remoteDataSource: sl()));

  sl.registerSingleton<CheckTokenUseCase>(CheckTokenUseCase(sl()));
  sl.registerSingleton<SaveTokenUseCase>(SaveTokenUseCase(sl()));
  sl.registerSingleton<RemoveTokenUseCase>(RemoveTokenUseCase(sl()));
  sl.registerSingleton<ValidateTokenUseCase>(ValidateTokenUseCase(sl()));

  sl.registerSingleton<GetServersUseCase>(GetServersUseCase(sl()));
  sl.registerSingleton<GetDomainsUseCase>(GetDomainsUseCase(sl()));

  sl.registerSingleton<domains.GetDomainsUseCase>(
    domains.GetDomainsUseCase(repository: sl()),
  );

  sl.registerSingleton<CheckDomainAvailabilityUseCase>(
    CheckDomainAvailabilityUseCase(repository: sl()),
  );

  sl.registerSingleton<GetWhoisUseCase>(GetWhoisUseCase(repository: sl()));

  sl.registerSingleton<GetSubscriptionsUseCase>(
    GetSubscriptionsUseCase(repository: sl()),
  );

  sl.registerSingleton<GetPaymentMethodsUseCase>(
    GetPaymentMethodsUseCase(repository: sl()),
  );

  sl.registerSingleton<DeletePaymentMethodUseCase>(
    DeletePaymentMethodUseCase(repository: sl()),
  );

  sl.registerSingleton<SetDefaultPaymentMethodUseCase>(
    SetDefaultPaymentMethodUseCase(repository: sl()),
  );

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

  sl.registerFactory<StartupBloc>(
    () => StartupBloc(
      checkTokenUseCase: sl(),
      saveTokenUseCase: sl(),
      removeTokenUseCase: sl(),
      validateTokenUseCase: sl(),
    ),
  );

  sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      getServersUseCase: sl(),
      getDomainsUseCase: sl(),
      checkTokenUseCase: sl(),
    ),
  );

  sl.registerFactory<DomainsBloc>(() => DomainsBloc(
        getDomainsUseCase: sl(),
        checkDomainAvailabilityUseCase: sl(),
      ));

  sl.registerFactory<BillingCubit>(
    () => BillingCubit(getSubscriptionsUseCase: sl()),
  );

  sl.registerFactory<PaymentMethodsCubit>(
    () => PaymentMethodsCubit(
      getPaymentMethodsUseCase: sl(),
      deletePaymentMethodUseCase: sl(),
      setDefaultPaymentMethodUseCase: sl(),
    ),
  );

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
