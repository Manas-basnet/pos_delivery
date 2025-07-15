import 'package:pos_delivery_mobile/core/network/api_result.dart';

abstract class AuthFailureCallback {
  void onAuthFailure(String message, FailureType type);
}

class AuthFailureHandler {
  AuthFailureCallback? _callback;
  
  void setCallback(AuthFailureCallback callback) {
    _callback = callback;
  }
  
  void handleAuthFailure(String message, FailureType type) {
    if (type == FailureType.auth) {
      _callback?.onAuthFailure(message, type);
    }
  }
}