import 'dart:async';
import 'package:pos_delivery_mobile/core/network/api_result.dart';
import 'package:pos_delivery_mobile/features/auth/domain/events/auth_event.dart';
import 'package:pos_delivery_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:pos_delivery_mobile/features/auth/domain/services/auth_service.dart';

class AuthServiceImpl implements AuthService {
  final AuthRepository _authRepository;
  final _authEventController = StreamController<AuthEvent>.broadcast();

  AuthServiceImpl({required AuthRepository authRepository}) 
      : _authRepository = authRepository;

  @override
  Stream<AuthEvent> get authEventStream => _authEventController.stream;

  @override
  Future<String?> getCurrentToken() async {
    final result = await _authRepository.getCurrentToken();
    return result.data;
  }

  @override
  Future<String?> refreshToken() async {
    final result = await _authRepository.refreshToken();
    return result.fold(
      onSuccess: (token) {
        _authEventController.add(TokenRefreshedEvent(token));
        return token;
      },
      onFailure: (message, type) {
        _authEventController.add(AuthenticationFailedEvent(message));
        return null;
      },
    );
  }

  @override
  Future<void> forceLogout() async {
    _authEventController.add(ForceLogoutEvent());
  }

  @override
  void dispose() {
    _authEventController.close();
  }
}