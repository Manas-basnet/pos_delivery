import 'package:get_it/get_it.dart';
import 'package:udharoo/core/network/dio_client.dart';
import 'package:udharoo/core/services/device_info_service.dart';
import 'package:udharoo/features/auth/data/datasources/local/shared_prefs_auth_local_datasource_impl.dart';
import 'package:udharoo/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart';
import 'package:udharoo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:udharoo/features/auth/data/services/auth_service_impl.dart';
import 'package:udharoo/features/auth/domain/datasources/local/auth_local_datasource.dart';
import 'package:udharoo/features/auth/domain/datasources/remote/auth_remote_datasource.dart';
import 'package:udharoo/features/auth/domain/repositories/auth_repository.dart';
import 'package:udharoo/features/auth/domain/services/auth_service.dart';
import 'package:udharoo/features/auth/domain/usecases/get_current_token_usecase.dart';
import 'package:udharoo/features/auth/domain/usecases/is_authenticated_usecase.dart';
import 'package:udharoo/features/auth/domain/usecases/login_usecase.dart';
import 'package:udharoo/features/auth/domain/usecases/logout_usecase.dart';
import 'package:udharoo/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:udharoo/features/auth/presentation/bloc/auth_cubit.dart';

Future<void> initAuth(GetIt sl) async {
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase(sl()));
  sl.registerLazySingleton(() => IsAuthenticatedUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentTokenUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      networkInfo: sl(),
      localDatasource: sl(),
      remoteDatasource: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(
      dioClient: sl<DioClient>(instanceName: 'authDioClient'),
      deviceInfoService: sl<DeviceInfoService>(),
    ),
  );

  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(),
  );

  sl.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(authRepository: sl()),
  );

  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      refreshTokenUseCase: sl(),
      isAuthenticatedUseCase: sl(),
      getCurrentTokenUseCase: sl(),
      authService: sl(),
    ),
  );
}