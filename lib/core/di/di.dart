import 'package:get_it/get_it.dart';
import 'package:pos_delivery_mobile/core/di/auth_di.dart';
import 'package:pos_delivery_mobile/core/di/core_di.dart';

final sl = GetIt.instance;

init() {
  initCore(sl);
  initAuth(sl);
}
