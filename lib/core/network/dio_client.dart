import 'package:dio/dio.dart';
import 'package:pos_delivery_mobile/config/app_config.dart';

class DioClient {
  late final Dio _dio;
  
  DioClient() {
    _dio = Dio();
    _configureDio();
  }
  
  void _configureDio() {
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
  
  void updateToken(String? token) {
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }
}