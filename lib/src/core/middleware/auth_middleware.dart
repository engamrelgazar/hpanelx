import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hpanelx/src/core/di/injection_container.dart';
import 'package:hpanelx/src/modules/startup/domain/usecases/check_token_usecase.dart';

class AuthMiddleware {
  static Future<String?> guard(
    BuildContext context,
    GoRouterState state,
  ) async {
    final checkTokenUseCase = sl<CheckTokenUseCase>();
    final result = await checkTokenUseCase();

    return result.fold(
      (failure) {
        final requestedLocation = state.matchedLocation;
        if (requestedLocation != '/token') {
          return '/token?redirect=${Uri.encodeComponent(requestedLocation)}';
        }
        return '/token';
      },
      (token) {
        if (token == null || token.isEmpty) {
          final requestedLocation = state.matchedLocation;
          if (requestedLocation != '/token') {
            return '/token?redirect=${Uri.encodeComponent(requestedLocation)}';
          }
          return '/token';
        }

        return null;
      },
    );
  }
}
