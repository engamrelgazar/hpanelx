import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/di/injection_container.dart';
import 'package:hpanelx/src/core/middleware/auth_middleware.dart';
import 'package:hpanelx/src/modules/startup/presentation/pages/splash_screen.dart';
import 'package:hpanelx/src/modules/startup/presentation/pages/token_input_page.dart';
import 'package:hpanelx/src/modules/home/presentation/pages/home_page.dart';
import 'package:hpanelx/src/modules/domains/presentation/pages/domains_page.dart';
import 'package:hpanelx/src/modules/domains/presentation/bloc/domains_bloc.dart';
import 'package:hpanelx/src/modules/vms/presentation/pages/vms_page.dart';
import 'package:hpanelx/src/modules/vms/presentation/cubit/vms_cubit.dart';
import 'package:hpanelx/src/modules/billing/presentation/pages/subscriptions_page.dart';
import 'package:hpanelx/src/modules/billing/presentation/cubit/billing_cubit.dart';

abstract class AppRouter {
  GoRouter get router;
}

class AppRouterImpl implements AppRouter {
  @override
  GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // Skip token check for splash and token input pages
      if (state.matchedLocation == '/' || state.matchedLocation == '/token') {
        return null;
      }

      // Use middleware to check for token
      return await AuthMiddleware.guard(context, state);
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/token',
        builder: (context, state) => const TokenInputPage(),
      ),
      // Protected pages
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/domains',
        builder:
            (context, state) => BlocProvider<DomainsBloc>(
              create: (context) => sl<DomainsBloc>(),
              child: const DomainsPage(),
            ),
      ),
      GoRoute(
        path: '/vms',
        builder:
            (context, state) => BlocProvider<VmsCubit>(
              create: (context) => sl<VmsCubit>(),
              child: const VmsPage(),
            ),
      ),
      GoRoute(
        path: '/billing/subscriptions',
        builder:
            (context, state) => BlocProvider<BillingCubit>(
              create: (context) => sl<BillingCubit>(),
              child: const SubscriptionsPage(),
            ),
      ),
    ],
  );
}
