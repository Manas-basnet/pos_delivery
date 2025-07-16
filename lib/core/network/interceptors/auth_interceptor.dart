import 'package:dio/dio.dart';
import 'package:udharoo/features/auth/domain/services/auth_service.dart';

class AuthInterceptor extends Interceptor {
  final AuthService _authService;
  
  AuthInterceptor({required AuthService authService}) : _authService = authService;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _authService.getCurrentToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    
    if (response?.statusCode == 401) {
      if (await _tryRefreshToken(err, handler)) {
        return;
      }
      
      await _authService.forceLogout();
      handler.next(err);
      return;
    }
    
    if (response?.statusCode == 403) {
      await _authService.forceLogout();
      handler.next(err);
      return;
    }
    
    handler.next(err);
  }

  Future<bool> _tryRefreshToken(DioException err, ErrorInterceptorHandler handler) async {
    try {
      final newToken = await _authService.refreshToken();
      if (newToken == null || newToken.isEmpty) {
        return false;
      }
      
      final requestOptions = err.requestOptions;
      requestOptions.headers['Authorization'] = 'Bearer $newToken';
      
      final response = await Dio().fetch(requestOptions);
      handler.resolve(response);
      return true;
    } catch (e) {
      return false;
    }
  }
}