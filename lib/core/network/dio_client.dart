import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:udharoo/config/app_config.dart';
import 'package:udharoo/core/network/interceptors/auth_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  late final Dio _dio;

  DioClient({AuthInterceptor? authInterceptor, String? baseUrl}) {
    _dio = Dio();
    _configureDio(authInterceptor, baseUrl);
  }

  void _configureDio(AuthInterceptor? authInterceptor, String? baseUrl) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl ?? AppConfig.posBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (authInterceptor != null) {
      _dio.interceptors.add(authInterceptor);
    }

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        enabled: AppConfig.flavor != AppFlavor.prod,
        logPrint: (object) {
          debugPrint(object.toString());
        },
      ),
    );
  }

  Dio get dio => _dio;
}
