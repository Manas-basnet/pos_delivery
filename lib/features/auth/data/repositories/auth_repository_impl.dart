import 'package:pos_delivery_mobile/core/data/base_repository.dart';
import 'package:pos_delivery_mobile/core/network/api_result.dart';
import 'package:pos_delivery_mobile/core/utils/exception_handler.dart';
import 'package:pos_delivery_mobile/features/auth/data/models/login_response_model.dart';
import 'package:pos_delivery_mobile/features/auth/data/models/logout_response_model.dart';
import 'package:pos_delivery_mobile/features/auth/domain/datasources/local/auth_local_datasource.dart';
import 'package:pos_delivery_mobile/features/auth/domain/datasources/remote/auth_remote_datasource.dart';
import 'package:pos_delivery_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:pos_delivery_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  AuthRepositoryImpl({
    required super.networkInfo,
    required this.localDatasource,
    required this.remoteDatasource,
  });

  final AuthLocalDatasource localDatasource;
  final AuthRemoteDatasource remoteDatasource;

  @override
  Future<ApiResult<AuthUser>> login(String username, String password) async {
    return ExceptionHandler.handleExceptions(() async {
      final result = await handleRemoteCallFirst<LoginResponseModel>(
        remoteCall: () async {
          final response = await remoteDatasource.login(username, password);
          return ApiResult.success(response);
        },
        saveLocalData: (loginResponse) async {
          if (loginResponse?.token != null) {
            await localDatasource.saveToken(loginResponse!.token!);
            if (loginResponse.refreshToken != null) {
              await localDatasource.saveRefreshToken(loginResponse.refreshToken!);
            }
          }
        },
      );

      return result.fold(
        onSuccess: (loginResponse) {
          if (loginResponse.token == null) {
            return ApiResult.failure('Login failed: No token received', FailureType.validation);
          }
          
          final authUser = AuthUser(
            token: loginResponse.token!,
            refreshToken: loginResponse.refreshToken,
          );
          
          return ApiResult.success(authUser);
        },
        onFailure: (message, type) => ApiResult.failure(message, type),
      );
    });
  }

  @override
  Future<ApiResult<void>> logout() async {
    return ExceptionHandler.handleExceptions(() async {
      final result = await handleRemoteCallFirst<LogoutResponseModel>(
        remoteCall: () async {
          final response = await remoteDatasource.logout();
          return ApiResult.success(response);
        },
        saveLocalData: (logoutResponse) async {
          await localDatasource.clearTokens();
        },
      );

      return result.fold(
        onSuccess: (_) => ApiResult.success(null),
        onFailure: (message, type) => ApiResult.failure(message, type),
      );
    });
  }

  @override
  Future<ApiResult<String>> refreshToken() async {
    return ExceptionHandler.handleExceptions(() async {
      final tokenResult = await localDatasource.getRefreshToken();
      
      if (tokenResult == null) {
        return ApiResult.failure('No refresh token available', FailureType.auth);
      }

      final newToken = await remoteDatasource.refreshToken(tokenResult);
      await localDatasource.saveToken(newToken);
      return ApiResult.success(newToken);
    });
  }

  @override
  Future<ApiResult<String?>> getCurrentToken() async {
    return ExceptionHandler.handleExceptions(() async {
      final token = await localDatasource.getToken();
      return ApiResult.success(token);
    });
  }

  @override
  Future<ApiResult<bool>> isAuthenticated() async {
    return ExceptionHandler.handleExceptions(() async {
      final token = await localDatasource.getToken();
      
      if (token == null || token.isEmpty) {
        return ApiResult.success(false);
      }

      final isValid = await remoteDatasource.validateToken(token);
      
      if (!isValid) {
        await localDatasource.clearTokens();
        return ApiResult.success(false);
      }

      return ApiResult.success(true);
    });
  }
}