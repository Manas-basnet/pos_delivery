import 'package:udharoo/core/network/api_result.dart';
import 'package:udharoo/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<ApiResult<void>> call() {
    return repository.logout();
  }
}