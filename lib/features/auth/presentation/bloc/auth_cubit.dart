import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_delivery_mobile/core/network/api_result.dart';
import 'package:pos_delivery_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:pos_delivery_mobile/features/auth/domain/events/auth_event.dart';
import 'package:pos_delivery_mobile/features/auth/domain/services/auth_service.dart';
import 'package:pos_delivery_mobile/features/auth/domain/usecases/get_current_token_usecase.dart';
import 'package:pos_delivery_mobile/features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'package:pos_delivery_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:pos_delivery_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:pos_delivery_mobile/features/auth/domain/usecases/refresh_token_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RefreshTokenUseCase refreshTokenUseCase;
  final IsAuthenticatedUseCase isAuthenticatedUseCase;
  final GetCurrentTokenUseCase getCurrentTokenUseCase;
  final AuthService authService;

  late final StreamSubscription<AuthEvent> _authEventSubscription;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.refreshTokenUseCase,
    required this.isAuthenticatedUseCase,
    required this.getCurrentTokenUseCase,
    required this.authService,
  }) : super(const AuthInitial()) {
    _authEventSubscription = authService.authEventStream.listen(_handleAuthEvent);
    checkAuthStatus();
  }

  void _handleAuthEvent(AuthEvent event) {
    switch (event) {
      case TokenRefreshedEvent():
        _handleTokenRefreshed(event.newToken);
        break;
      case ForceLogoutEvent():
        _handleForceLogout();
        break;
      case AuthenticationFailedEvent():
        _handleAuthenticationFailed(event.reason);
        break;
    }
  }

  void _handleTokenRefreshed(String newToken) {
    if (state is AuthAuthenticated) {
      final currentUser = (state as AuthAuthenticated).user;
      emit(AuthAuthenticated(currentUser.copyWith(token: newToken)));
    }
  }

  void _handleForceLogout() {
    if (state is! AuthUnauthenticated) {
      emit(const AuthUnauthenticated());
    }
  }

  void _handleAuthenticationFailed(String reason) {
    if (state is! AuthUnauthenticated && state is! AuthError) {
      emit(AuthError(reason, FailureType.auth));
    }
  }

  Future<void> login(String username, String password) async {
    emit(const AuthLoading());

    final result = await loginUseCase(username, password);

    result.fold(
      onSuccess: (user) => emit(AuthAuthenticated(user)),
      onFailure: (message, type) => emit(AuthError(message, type)),
    );
  }

  Future<void> logout() async {
    emit(const AuthUnauthenticated());

    // final result = await logoutUseCase();

    // result.fold(
    //   onSuccess: (_) => emit(const AuthUnauthenticated()),
    //   onFailure: (message, type) => emit(const AuthUnauthenticated()),
    // );
  }

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());

    final result = await isAuthenticatedUseCase();

    result.fold(
      onSuccess: (isAuthenticated) async {
        if (isAuthenticated) {
          final tokenResult = await getCurrentTokenUseCase();
          tokenResult.fold(
            onSuccess: (token) {
              if (token != null && token.isNotEmpty) {
                emit(AuthAuthenticated(AuthUser(token: token)));
              } else {
                emit(const AuthUnauthenticated());
              }
            },
            onFailure: (_, __) => emit(const AuthUnauthenticated()),
          );
        } else {
          emit(const AuthUnauthenticated());
        }
      },
      onFailure: (message, type) => emit(AuthError(message, type)),
    );
  }

  Future<void> refreshToken() async {
    final result = await refreshTokenUseCase();

    result.fold(
      onSuccess: (newToken) {
        if (state is AuthAuthenticated) {
          final currentUser = (state as AuthAuthenticated).user;
          emit(AuthAuthenticated(currentUser.copyWith(token: newToken)));
        }
      },
      onFailure: (_, type) {
        if (type == FailureType.auth) {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  void resetError() {
    if (state is AuthError) {
      emit(const AuthInitial());
    }
  }

  @override
  Future<void> close() {
    _authEventSubscription.cancel();
    return super.close();
  }
}