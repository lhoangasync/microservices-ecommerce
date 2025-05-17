import 'package:ecommerce_app/features/authentication/screens/login/login.dart';
import 'package:ecommerce_app/features/authentication/screens/onboarding/onboarding.dart';
import 'package:ecommerce_app/navigation_menu.dart';
import 'package:ecommerce_app/utils/local_storage/storage_utility.dart';
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
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String userId = '';

        if (decodedToken.containsKey('user') &&
            decodedToken['user'] is Map &&
            (decodedToken['user'] as Map).containsKey('id')) {
          userId = decodedToken['user']['id'];
          print('User ID extracted from token: $userId');
        } else {
          print('User ID not found in token, using default');
          userId = 'default_user';
        }
        await TLocalStorage.init(userId);
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
