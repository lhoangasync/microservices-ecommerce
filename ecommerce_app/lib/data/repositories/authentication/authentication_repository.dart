import 'package:ecommerce_app/features/authentication/screens/login/login.dart';
import 'package:ecommerce_app/features/authentication/screens/onboarding/onboarding.dart';
import 'package:ecommerce_app/navigation_menu.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();

  // Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  // Function to show relevant screen
  screenRedirect() async {
    deviceStorage.writeIfNull('isFirstTime', true);

    if (deviceStorage.read('isFirstTime') == true) {
      Get.offAll(() => const OnBoardingScreen());
      return;
    }

    final token = deviceStorage.read('ACCESS_TOKEN');
    if (token != null && token.toString().isNotEmpty) {
      final isExpired = JwtDecoder.isExpired(token);

      if (!isExpired) {
        Get.offAll(() => const NavigationMenu());
      } else {
        deviceStorage.remove('ACCESS_TOKEN');
        Get.offAll(() => const LoginScreen());
      }
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }
}
