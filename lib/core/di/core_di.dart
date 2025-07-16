import 'package:get_it/get_it.dart';
import 'package:pos_delivery_mobile/config/app_config.dart';
import 'package:pos_delivery_mobile/core/network/dio_client.dart';
import 'package:pos_delivery_mobile/core/network/network_info.dart';
import 'package:pos_delivery_mobile/core/network/interceptors/auth_interceptor.dart';
import 'package:pos_delivery_mobile/core/services/jwt_service.dart';
import 'package:pos_delivery_mobile/core/services/device_info_service.dart';

Future<void> initCore(GetIt sl) async {
  sl.registerLazySingleton<JwtService>(() => JwtServiceImpl());
  sl.registerLazySingleton<DeviceInfoService>(() => DeviceInfoServiceImpl());
  
  sl.registerLazySingleton<DioClient>(
    () => DioClient(baseUrl: AppConfig.authBaseUrl),
    instanceName: 'authDioClient',
  );
  
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(authService: sl()),
  );
  
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      authInterceptor: sl<AuthInterceptor>(),
      baseUrl: AppConfig.posBaseUrl,
    ),
    instanceName: 'mainDioClient',
  );
}