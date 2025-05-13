import 'package:ecommerce_app/app.dart';
import 'package:ecommerce_app/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  // Add Widgets Bindinng
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Init Local Storage
  await GetStorage.init();

  // Await Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize
  Get.put(AuthenticationRepository());
  // Todo: Initialize Authentication

  runApp(const App());
}
