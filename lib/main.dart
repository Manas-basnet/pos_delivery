import 'package:flutter/material.dart';
import 'package:pos_delivery_mobile/config/app_config.dart';
import 'package:pos_delivery_mobile/core/di/di.dart' as di;
import 'package:pos_delivery_mobile/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  AppConfig.setFlavor(AppFlavor.dev);
  
  di.init();
  
  runApp(const MyApp());
}
