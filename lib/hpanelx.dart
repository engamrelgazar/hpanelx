import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/di/injection_container.dart' as di;
import 'package:hpanelx/src/core/routes/app_router.dart';
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:hpanelx/src/modules/home/presentation/bloc/home_bloc.dart';
import 'package:hpanelx/src/modules/startup/presentation/bloc/startup_bloc.dart';

class Hpanelx extends StatelessWidget {
  const Hpanelx({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<StartupBloc>(create: (context) => di.sl<StartupBloc>()),
          BlocProvider<HomeBloc>(create: (context) => di.sl<HomeBloc>()),
        ],
        child: MaterialApp.router(
          title: 'HPanelX',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: di.sl<AppRouter>().router,
        ),
      ),
    );
  }
}
