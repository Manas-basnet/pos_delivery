import 'package:pos_delivery_mobile/core/network/api_result.dart';
import 'package:pos_delivery_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:pos_delivery_mobile/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<ApiResult<AuthUser>> call(String username, String password) {
    return repository.login(username, password);
  }
}