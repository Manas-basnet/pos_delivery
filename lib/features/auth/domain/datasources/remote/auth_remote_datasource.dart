import 'package:pos_delivery_mobile/features/auth/data/models/login_response_model.dart';
import 'package:pos_delivery_mobile/features/auth/data/models/logout_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponseModel> login(String username, String password);
  Future<LogoutResponseModel> logout();
  Future<String> refreshToken(String currentToken);
  Future<bool> validateToken(String token);
}