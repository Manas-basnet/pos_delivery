import 'package:pos_delivery_mobile/core/network/api_result.dart';
import 'package:pos_delivery_mobile/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentTokenUseCase {
  final AuthRepository repository;

  GetCurrentTokenUseCase(this.repository);

  Future<ApiResult<String?>> call() {
    return repository.getCurrentToken();
  }
}