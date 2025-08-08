import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/di/injection_container.dart' as di;
import 'package:hpanelx/src/core/routes/app_router.dart';
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'package:hpanelx/src/core/theme/theme_cubit.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:hpanelx/src/modules/home/presentation/bloc/home_bloc.dart';
import 'package:hpanelx/src/modules/startup/presentation/bloc/startup_bloc.dart';

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
                final mediaQuery = MediaQuery.of(context);

                final currentScale = mediaQuery.textScaler.scale(1.0);
                final clampedScale = currentScale.clamp(0.8, 1.2);

                final newTextScaler = TextScaler.linear(clampedScale);

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
