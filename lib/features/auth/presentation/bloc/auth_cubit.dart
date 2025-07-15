import 'package:equatable/equatable.dart';
import 'package:pos_delivery_mobile/core/network/api_result.dart';
import 'package:pos_delivery_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.refreshTokenUseCase,
    required this.isAuthenticatedUseCase,
    required this.getCurrentTokenUseCase,
  }) : super(const AuthInitial()) {
    checkAuthStatus();
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
    emit(const AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      onSuccess: (_) => emit(const AuthUnauthenticated()),
      onFailure: (message, type) => emit(AuthError(message, type)),
    );
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
              if (token != null) {
                emit(AuthAuthenticated(AuthUser(token: token)));
              } else {
                emit(const AuthUnauthenticated());
              }
            },
            onFailure: (message, type) => emit(const AuthUnauthenticated()),
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
      onFailure: (message, type) => emit(const AuthUnauthenticated()),
    );
  }

  void resetToUnauthenticated() {
    emit(const AuthUnauthenticated());
  }

  void resetError() {
    emit(const AuthInitial());
  }
}