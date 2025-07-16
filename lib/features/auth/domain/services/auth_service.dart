import 'dart:async';
import 'package:udharoo/features/auth/domain/events/auth_event.dart';

abstract class AuthService {
  Future<String?> getCurrentToken();
  Future<String?> refreshToken();
  Future<void> forceLogout();
  Stream<AuthEvent> get authEventStream;
  void dispose();
}