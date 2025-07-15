import 'package:get_it/get_it.dart';
import 'package:pos_delivery_mobile/core/network/dio_client.dart';
import 'package:pos_delivery_mobile/core/network/network_info.dart';

Future<void> initCore(GetIt sl) async {
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}