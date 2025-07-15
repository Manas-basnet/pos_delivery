import 'package:dio/dio.dart';
import 'package:pos_delivery_mobile/config/app_config.dart';
import 'package:pos_delivery_mobile/core/network/interceptors/auth_interceptor.dart';

class DioClient {
  late final Dio _dio;
  
  DioClient({AuthInterceptor? authInterceptor}) {
    _dio = Dio();
    _configureDio(authInterceptor);
  }
  
  void _configureDio(AuthInterceptor? authInterceptor) {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
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
    
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) {
        if (AppConfig.flavor != AppFlavor.prod) {
          print(object);
        }
      },
    ));
  }
  
  Dio get dio => _dio;
}