import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hpanelx/src/core/utils/utils.dart';
import 'package:hpanelx/src/core/theme/theme_cubit.dart';
import 'package:hpanelx/src/modules/startup/presentation/bloc/startup_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check for token after animation
    Future.delayed(const Duration(seconds: 3), () {
      _checkToken();
    });
  }

  void _checkToken() {
    context.read<StartupBloc>().add(CheckTokenEvent());
  }

  void _validateToken() {
    context.read<StartupBloc>().add(ValidateTokenEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<StartupBloc, StartupState>(
        listener: (context, state) {
          if (state is TokenAvailable) {
            _validateToken();
          } else if (state is TokenNotAvailable) {
            context.go('/token');
          } else if (state is TokenValidated) {
            if (state.isValid) {
              context.go('/home');
            } else {
              context.read<StartupBloc>().add(LogoutEvent());
              context.go('/token');
            }
          }
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: BlocBuilder<ThemeCubit, AppThemeMode>(
                  builder: (context, themeMode) {
                    // Check if current theme is dark
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;

                                        return Image.asset(
                      isDark 
                        ? "assets/images/white-logo-removed-background.png"
                        : "assets/images/colored-logo-removed-background.png",
                      height: ResponsiveHelper.h(180, context),
                      width: ResponsiveHelper.w(180, context),
                    );
                  },
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(30, context)),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
