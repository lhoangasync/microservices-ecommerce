import 'package:ecommerce_app/navigation_menu.dart';
import 'package:ecommerce_app/utils/constants/image_strings.dart';
import 'package:ecommerce_app/utils/helpers/network_manager.dart';
import 'package:ecommerce_app/utils/http/http_client.dart';
import 'package:ecommerce_app/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    // Load saved credentials if available
    final savedEmail = localStorage.read('REMEMBER_ME_EMAIL');
    final savedPassword = localStorage.read('REMEMBER_ME_PASSWORD');

    if (savedEmail != null && savedPassword != null) {
      email.text = savedEmail;
      password.text = savedPassword;
      rememberMe.value = true;
    }
  }

  Future<void> signIn() async {
    try {
      // Start loading
      TFullScreenLoader.openLoadingDialog(
        'Logging you in...',
        TImages.docerAnimation,
      );

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // form validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      final data = {
        "email": email.text.trim(),
        "password": password.text.trim(),
      };

      // connect backend
      final response = await THttpHelper.post('identity/auth/login', data);

      if (kDebugMode) {
        print("-----------------------Login response: $response");
      }

      // remove loading
      TFullScreenLoader.stopLoading();

      if (response['code'] == 200) {
        // Save the token to localStorage after successful login
        final token = response['data']['data']['access_token'];
        print('----check token: $token');
        if (token != null) {
          localStorage.write('ACCESS_TOKEN', token);
        }
        TLoaders.successSnackBar(
          title: 'Sign In!',
          message: response['message'],
        );
        Get.offAll(() => NavigationMenu());
      } else {
        TLoaders.errorSnackBar(
          title: 'Failed to log in!',
          message: response['message'],
        );
      }

      // redirect
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'On Snap', message: e.toString());
    }
  }
}
