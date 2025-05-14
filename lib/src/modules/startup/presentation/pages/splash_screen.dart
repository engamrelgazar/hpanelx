import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'package:hpanelx/src/core/utils/utils.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<StartupBloc, StartupState>(
        listener: (context, state) {
          if (state is TokenAvailable) {
            context.go('/home');
          } else if (state is TokenNotAvailable) {
            context.go('/token');
          }
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image.asset("assets/images/logo.png")),
              SizedBox(height: ResponsiveHelper.h(10, context)),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
