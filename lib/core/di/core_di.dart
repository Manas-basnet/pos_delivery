import 'package:get_it/get_it.dart';
import 'package:pos_delivery_mobile/core/network/dio_client.dart';
import 'package:pos_delivery_mobile/core/network/network_info.dart';
import 'package:pos_delivery_mobile/core/network/interceptors/auth_interceptor.dart';

Future<void> initCore(GetIt sl) async {
  sl.registerLazySingleton<DioClient>(
    () => DioClient(),
    instanceName: 'authDioClient',
  );
  
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(authService: sl()),
  );
  
  sl.registerLazySingleton<DioClient>(
    () => DioClient(authInterceptor: sl<AuthInterceptor>()),
    instanceName: 'mainDioClient',
  );
}