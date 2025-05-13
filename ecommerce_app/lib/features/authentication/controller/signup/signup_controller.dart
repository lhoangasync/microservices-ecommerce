import 'package:ecommerce_app/features/authentication/screens/signup/verify_email.dart';
import 'package:ecommerce_app/utils/constants/image_strings.dart';
import 'package:ecommerce_app/utils/helpers/network_manager.dart';
import 'package:ecommerce_app/utils/http/http_client.dart';
import 'package:ecommerce_app/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final firstName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // SIGNUP
  Future<void> signup() async {
    try {
      // Start loading
      TFullScreenLoader.openLoadingDialog(
        'We are processing your information...',
        TImages.docerAnimation,
      );

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // form validation
      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // privacy policy check
      if (!privacyPolicy.value) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message:
              'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.',
        );
        return;
      }

      // save authenticated user data
      final data = {
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'username': username.text.trim(),
        'email': email.text.trim(),
        'password': password.text.trim(),
        'phone': phoneNumber.text.trim(),
      };

      final response = await THttpHelper.post('identity/auth/register', data);

      if (kDebugMode) {
        print("-----------------------Raw response: $response");
      }

      // Remove loader
      TFullScreenLoader.stopLoading();

      // show success message
      if (response['code'] == 201) {
        TLoaders.successSnackBar(
          title: 'Register Successfully!',
          message: response['message'],
        );
        Get.to(() => VerifyEmailScreen(email: email.text.trim()));
      } else {
        // TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'Failed to Register!',
          message: response['message'],
        );
      }
    } catch (e) {
      // show some generic error to the user
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    }
  }
}
