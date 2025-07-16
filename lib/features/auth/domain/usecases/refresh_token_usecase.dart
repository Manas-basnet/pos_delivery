import 'package:udharoo/core/network/api_result.dart';
import 'package:udharoo/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<ApiResult<String>> call() {
    return repository.refreshToken();
  }
}