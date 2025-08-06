import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/di/injection_container.dart' as di;
import 'package:hpanelx/src/core/middleware/auth_middleware.dart';
import 'package:hpanelx/src/modules/startup/presentation/pages/splash_screen.dart';
import 'package:hpanelx/src/modules/startup/presentation/pages/token_input_page.dart';
import 'package:hpanelx/src/modules/home/presentation/pages/home_page.dart';
import 'package:hpanelx/src/modules/domains/presentation/pages/domains_page.dart';
import 'package:hpanelx/src/modules/domains/presentation/bloc/domains_bloc.dart';
import 'package:hpanelx/src/modules/vms/presentation/pages/vms_page.dart';
import 'package:hpanelx/src/modules/vms/presentation/cubit/vms_cubit.dart';
import 'package:hpanelx/src/modules/billing/presentation/pages/subscriptions_page.dart';
import 'package:hpanelx/src/modules/billing/presentation/pages/payment_methods_page.dart';
import 'package:hpanelx/src/modules/billing/presentation/cubit/billing_cubit.dart';
import 'package:hpanelx/src/modules/billing/presentation/cubit/payment_methods_cubit.dart';

/// Route name constants for the application
class AppRoutes {
  // Startup routes
  static const String splash = '/';
  static const String tokenInput = '/token';

  // Main routes
  static const String home = '/home';
  static const String domains = '/domains';
  static const String virtualMachines = '/vms';

  // Billing routes
  static const String subscriptions = '/billing/subscriptions';
  static const String paymentMethods = '/billing/payment-methods';

  // Helper methods for navigation
  static String domainDetails(String domainId) => '$domains/$domainId';
  static String vmDetails(String vmId) => '$virtualMachines/$vmId';
}

/// Router interface
abstract class AppRouter {
  GoRouter get router;
}

/// Router implementation
class AppRouterImpl implements AppRouter {
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  @override
  GoRouter get router => _router;

  late final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: _handleRedirect,
    routes: _buildRoutes(),
  );

  /// Handle redirect logic
  Future<String?> _handleRedirect(
      BuildContext context, GoRouterState state) async {
    // Skip token check for splash and token input pages
    if (state.matchedLocation == AppRoutes.splash ||
        state.matchedLocation == AppRoutes.tokenInput) {
      return null;
    }

    // Use middleware to check for token
    return await AuthMiddleware.guard(context, state);
  }

  /// Build the application routes
  List<RouteBase> _buildRoutes() {
    return [
      // Startup routes
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.tokenInput,
        name: 'tokenInput',
        builder: (context, state) => const TokenInputPage(),
      ),

      // Home route
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Domains routes
      GoRoute(
        path: AppRoutes.domains,
        name: 'domains',
        builder: (context, state) => BlocProvider<DomainsBloc>(
          create: (context) => di.sl<DomainsBloc>(),
          child: const DomainsPage(),
        ),
      ),

      // Virtual Machines routes
      GoRoute(
        path: AppRoutes.virtualMachines,
        name: 'virtualMachines',
        builder: (context, state) => BlocProvider<VmsCubit>(
          create: (context) => di.sl<VmsCubit>(),
          child: const VmsPage(),
        ),
      ),

      // Billing routes
      GoRoute(
        path: AppRoutes.subscriptions,
        name: 'subscriptions',
        builder: (context, state) => BlocProvider<BillingCubit>(
          create: (context) => di.sl<BillingCubit>(),
          child: const SubscriptionsPage(),
        ),
      ),

      GoRoute(
        path: AppRoutes.paymentMethods,
        name: 'paymentMethods',
        builder: (context, state) => BlocProvider<PaymentMethodsCubit>(
          create: (context) => di.sl<PaymentMethodsCubit>(),
          child: const PaymentMethodsPage(),
        ),
      ),
    ];
  }
}
