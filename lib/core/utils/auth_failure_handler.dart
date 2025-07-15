import 'package:pos_delivery_mobile/core/network/api_result.dart';
import 'package:pos_delivery_mobile/features/auth/presentation/bloc/auth_cubit.dart';

class AuthFailureHandler {
  final AuthCubit authCubit;
  
  AuthFailureHandler(this.authCubit);
  
  void handleAuthFailure(String message, FailureType type) {
    if (type == FailureType.auth) {
      authCubit.logout();
    }
  }
}