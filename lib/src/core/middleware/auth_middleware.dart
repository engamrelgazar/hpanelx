import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hpanelx/src/core/di/injection_container.dart';
import 'package:hpanelx/src/modules/startup/domain/usecases/check_token_usecase.dart';

/// Auth middleware to verify token before allowing access to protected pages
class AuthMiddleware {
  static Future<String?> guard(
    BuildContext context,
    GoRouterState state,
  ) async {
    // Check token using CheckTokenUseCase
    final checkTokenUseCase = sl<CheckTokenUseCase>();
    final result = await checkTokenUseCase();

    // Use fold to handle the result
    return result.fold(
      (failure) {
        // On failure, redirect to token input page with return path
        final requestedLocation = state.matchedLocation;
        if (requestedLocation != '/token') {
          return '/token?redirect=${Uri.encodeComponent(requestedLocation)}';
        }
        return '/token';
      },
      (token) {
        // Check if token exists and is valid
        if (token == null || token.isEmpty) {
          // If token doesn't exist, redirect to token input page
          final requestedLocation = state.matchedLocation;
          if (requestedLocation != '/token') {
            return '/token?redirect=${Uri.encodeComponent(requestedLocation)}';
          }
          return '/token';
        }

        // If token exists, allow access to requested page
        return null;
      },
    );
  }
}
