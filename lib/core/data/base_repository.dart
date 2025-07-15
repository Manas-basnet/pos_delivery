import 'dart:async';
import 'package:pos_delivery_mobile/core/data/base_response.dart';
import 'package:pos_delivery_mobile/core/network/api_result.dart';
import 'package:pos_delivery_mobile/core/network/network_info.dart';
import 'package:pos_delivery_mobile/core/utils/exception_handler.dart';
import 'package:pos_delivery_mobile/core/utils/auth_failure_handler.dart';

abstract class BaseRepository {
  BaseRepository({
    required this.networkInfo,
    required this.authFailureHandler,
  });

  final NetworkInfo networkInfo;
  final AuthFailureHandler authFailureHandler;

  FailureType _getFailureTypeFromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return FailureType.validation;
      case 401:
      case 403:
        return FailureType.auth;
      case 404:
        return FailureType.notFound;
      case 500:
      case 502:
      case 503:
      case 504:
        return FailureType.server;
      default:
        return FailureType.unknown;
    }
  }

  ApiResult<T> _validateResponse<T extends BaseResponseResult>(ApiResult<T> result) {
    if (result is Success<T>) {
      final data = result.data;
      final statusCode = data.statusCode;
      
      if (statusCode == null) {
        return ApiResult.failure('Missing status code', FailureType.validation);
      }
      
      if (statusCode >= 400) {
        final failureType = _getFailureTypeFromStatusCode(statusCode);
        final message = data.message ?? 'Request failed with status code $statusCode';
        
        if (failureType == FailureType.auth) {
          authFailureHandler.handleAuthFailure(message, failureType);
        }
        
        return ApiResult.failure(message, failureType);
      }
    }
    
    return result;
  }

  Future<ApiResult<T>> handleRemoteCallFirst<T extends BaseResponseResult>({
    required Future<ApiResult<T>> Function() remoteCall,
    Future<ApiResult<T>> Function()? localCall,
    required Future<void> Function(T? data) saveLocalData,
  }) async {
    return ExceptionHandler.handleExceptions(() async {
      if (!(await networkInfo.isConnected)) {
        if (localCall != null) {
          return await localCall();
        }
        return ApiResult.failure(
          'No internet connection',
          FailureType.network,
        );
      }

      final remoteResult = await remoteCall();
      final validatedResult = _validateResponse(remoteResult);
      
      if (validatedResult is Success) {
        try {
          await saveLocalData(validatedResult.data);
        } catch (e) {
          // Continue if local save fails
        }
      }

      return validatedResult;
    });
  }

  Future<ApiResult<T>> handleCacheCallFirst<T extends BaseResponseResult>({
    required Future<ApiResult<T>> Function() localCall,
    Future<ApiResult<T>> Function()? remoteCall,
    required Future<void> Function(T? data) saveLocalData,
  }) async {
    return ExceptionHandler.handleExceptions(() async {
      final result = await localCall();

      if (result.data != null) {
        return result;
      }

      if (!(await networkInfo.isConnected)) {
        return ApiResult.failure(
          'No internet connection',
          FailureType.network,
        );
      }

      if (remoteCall != null) {
        final remoteResult = await remoteCall();
        final validatedResult = _validateResponse(remoteResult);
        
        if (validatedResult is Success) {
          try {
            await saveLocalData(validatedResult.data);
          } catch (e) {
            // Continue if local save fails
          }
        }
        return validatedResult;
      }

      return ApiResult.failure(
        'No data available',
        FailureType.noData,
      );
    });
  }

  Future<ApiResult<T>> handleCacheCallFirstNoResponse<T>({
    required Future<ApiResult<T>> Function() localCall,
    Future<ApiResult<T>> Function()? remoteCall,
    required Future<void> Function(T? data) saveLocalData,
  }) async {
    return ExceptionHandler.handleExceptions(() async {
      final result = await localCall();

      if (result.data != null) {
        return result;
      }

      if (!(await networkInfo.isConnected)) {
        return ApiResult.failure(
          'No internet connection',
          FailureType.network,
        );
      }

      if (remoteCall != null) {
        final remoteResult = await remoteCall();
        
        if (remoteResult is Success) {
          try {
            await saveLocalData(remoteResult.data);
          } catch (e) {
            // Continue if local save fails
          }
        }
        return remoteResult;
      }

      return ApiResult.failure(
        'No data available',
        FailureType.noData,
      );
    });
  }
}