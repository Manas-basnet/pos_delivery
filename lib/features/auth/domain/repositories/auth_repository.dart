import 'package:udharoo/core/network/api_result.dart';
import 'package:udharoo/features/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<ApiResult<AuthUser>> login(String username, String password);
  Future<ApiResult<void>> logout();
  Future<ApiResult<bool>> isAuthenticated();
  Future<ApiResult<String?>> getCurrentToken();
  Future<ApiResult<String>> refreshToken();
}