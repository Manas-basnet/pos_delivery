import 'package:get_it/get_it.dart';
import 'package:udharoo/config/app_config.dart';
import 'package:udharoo/core/network/dio_client.dart';
import 'package:udharoo/core/network/network_info.dart';
import 'package:udharoo/core/network/interceptors/auth_interceptor.dart';
import 'package:udharoo/core/services/device_info_service.dart';
import 'package:udharoo/core/theme/theme_cubit/theme_cubit.dart';

Future<void> initCore(GetIt sl) async {
  sl.registerLazySingleton<DeviceInfoService>(() => DeviceInfoServiceImpl());
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  
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