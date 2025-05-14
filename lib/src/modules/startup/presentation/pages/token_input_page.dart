import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hpanelx/src/core/utils/utils.dart';
import 'package:hpanelx/src/modules/startup/presentation/bloc/startup_bloc.dart';

class TokenInputPage extends StatefulWidget {
  const TokenInputPage({super.key});

  @override
  State<TokenInputPage> createState() => _TokenInputPageState();
}

class _TokenInputPageState extends State<TokenInputPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Modern color scheme
  final Color _primaryGradientStart = const Color(0xFF6C63FF);
  final Color _cardColor = const Color(0xFFF8F9FA);
  final Color _textColor = const Color(0xFF2D3436);
  final Color _hintColor = const Color(0xFF636E72);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _saveToken() {
    if (_formKey.currentState!.validate()) {
      context.read<StartupBloc>().add(
        SaveTokenEvent(token: _tokenController.text),
      );
    }
  }

  // استخراج مسار إعادة التوجيه من معلمات URL
  String? _getRedirectPath() {
    final uri = Uri.parse(GoRouterState.of(context).uri.toString());
    return uri.queryParameters['redirect'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cardColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: BlocListener<StartupBloc, StartupState>(
        listener: (context, state) {
          if (state is TokenSaved) {
            // التحقق من وجود مسار إعادة توجيه
            final redirectPath = _getRedirectPath();
            if (redirectPath != null && redirectPath.isNotEmpty) {
              context.go(redirectPath);
            } else {
              context.go('/home');
            }
          } else if (state is StartupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade400,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.r(10, context),
                  ),
                ),
              ),
            );
          }
        },
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(24, context)),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(
                            ResponsiveHelper.w(20, context),
                          ),
                          decoration: BoxDecoration(
                            color: _primaryGradientStart.withAlpha(26),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.vpn_key_rounded,
                            size: ResponsiveHelper.responsiveIconSize(
                              context,
                              60,
                            ),
                            color: _primaryGradientStart,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(32, context)),
                      Text(
                        'Enter Bearer Token',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.sp(24, context),
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(8, context)),
                      Text(
                        'Please enter your API bearer token to authenticate',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.sp(14, context),
                          color: _hintColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(32, context)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.r(20, context),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryGradientStart.withAlpha(26),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            ResponsiveHelper.w(24, context),
                          ),
                          child: Column(
                            children: [
                              BlocBuilder<StartupBloc, StartupState>(
                                builder: (context, state) {
                                  final isTokenVisible =
                                      state is TokenVisibilityState
                                          ? state.isVisible
                                          : false;
                                  return TextFormField(
                                    controller: _tokenController,
                                    obscureText: !isTokenVisible,
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.sp(
                                        16,
                                        context,
                                      ),
                                      color: _textColor,
                                      letterSpacing: 0.5,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Bearer Token',
                                      hintText: 'Enter your bearer token',
                                      labelStyle: TextStyle(
                                        color: _hintColor,
                                        fontSize: ResponsiveHelper.sp(
                                          14,
                                          context,
                                        ),
                                      ),
                                      hintStyle: TextStyle(
                                        color: _hintColor.withAlpha(179),
                                        fontSize: ResponsiveHelper.sp(
                                          14,
                                          context,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.security,
                                        color: _primaryGradientStart,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isTokenVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: _primaryGradientStart,
                                        ),
                                        onPressed: () {
                                          context.read<StartupBloc>().add(
                                            ToggleTokenVisibilityEvent(),
                                          );
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveHelper.r(15, context),
                                        ),
                                        borderSide: BorderSide(
                                          color: _primaryGradientStart
                                              .withAlpha(51),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveHelper.r(15, context),
                                        ),
                                        borderSide: BorderSide(
                                          color: _primaryGradientStart
                                              .withAlpha(51),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveHelper.r(15, context),
                                        ),
                                        borderSide: BorderSide(
                                          color: _primaryGradientStart,
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: _cardColor,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a token';
                                      } else if (value.length < 8) {
                                        return 'Token too short';
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: ResponsiveHelper.h(24, context)),
                              BlocBuilder<StartupBloc, StartupState>(
                                builder: (context, state) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: ResponsiveHelper.h(55, context),
                                    child: ElevatedButton(
                                      onPressed:
                                          state is StartupLoading
                                              ? null
                                              : _saveToken,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _primaryGradientStart,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            ResponsiveHelper.r(15, context),
                                          ),
                                        ),
                                      ),
                                      child:
                                          state is StartupLoading
                                              ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                              : Text(
                                                'Authenticate',
                                                style: TextStyle(
                                                  fontSize: ResponsiveHelper.sp(
                                                    16,
                                                    context,
                                                  ),
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(20, context)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
