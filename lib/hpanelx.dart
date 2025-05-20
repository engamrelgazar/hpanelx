import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/di/injection_container.dart' as di;
import 'package:hpanelx/src/core/routes/app_router.dart';
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'package:hpanelx/src/core/theme/theme_cubit.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:hpanelx/src/modules/home/presentation/bloc/home_bloc.dart';
import 'package:hpanelx/src/modules/startup/presentation/bloc/startup_bloc.dart';

/// Main application widget that configures global providers and settings
class Hpanelx extends StatefulWidget {
  const Hpanelx({super.key});

  @override
  State<Hpanelx> createState() => _HpanelxState();
}

class _HpanelxState extends State<Hpanelx> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Reset ResponsiveHelper's cached size when metrics change
    ResponsiveHelper.resetCachedSize();
    super.didChangeMetrics();
  }


  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<StartupBloc>(create: (context) => di.sl<StartupBloc>()),
          BlocProvider<HomeBloc>(create: (context) => di.sl<HomeBloc>()),
          BlocProvider<ThemeCubit>(create: (context) => di.sl<ThemeCubit>()),
        ],
        child: BlocBuilder<ThemeCubit, AppThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              title: 'HPanelX',
              debugShowCheckedModeBanner: false,
              themeMode: context.read<ThemeCubit>().getThemeMode(),
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routerConfig: di.sl<AppRouter>().router,
              builder: (context, child) {
                // Apply a global font scaling
                final mediaQuery = MediaQuery.of(context);

                // Get current scale factor and apply clamp
                final currentScale = mediaQuery.textScaler.scale(1.0);
                final clampedScale = currentScale.clamp(0.8, 1.2);

                // Create new TextScaler with clamped scale
                final newTextScaler = TextScaler.linear(clampedScale);

                // Ensure we reset ResponsiveHelper's cached size when app rebuilds
                ResponsiveHelper.resetCachedSize();

                return MediaQuery(
                  data: mediaQuery.copyWith(textScaler: newTextScaler),
                  child: child!,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
