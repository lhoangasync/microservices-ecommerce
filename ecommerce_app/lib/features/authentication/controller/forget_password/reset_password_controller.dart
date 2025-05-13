import 'package:ecommerce_app/features/authentication/controller/signup/verify_email_controller.dart';
import 'package:ecommerce_app/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:ecommerce_app/utils/constants/image_strings.dart';
import 'package:ecommerce_app/utils/helpers/network_manager.dart';
import 'package:ecommerce_app/utils/http/http_client.dart';
import 'package:ecommerce_app/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  static ResetPasswordController get instance => Get.find();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  Future<void> recoverPassword() async {
    try {
      // Start loading
      TFullScreenLoader.openLoadingDialog(
        'Changing your password...',
        TImages.docerAnimation,
      );

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // form validation
      if (!resetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final data = {
        'email': VerifyEmailController.instance.email.value,
        'newPassword': password.text.trim(),
      };

      final response = await THttpHelper.post(
        'identity/auth/reset-password',
        data,
      );

      // Remove loader
      TFullScreenLoader.stopLoading();

      if (response['code'] == 200) {
        TLoaders.successSnackBar(
          title: 'Password',
          message: response['message'],
        );
        Get.to(() => ResetPassword());
      } else {
        TLoaders.errorSnackBar(title: 'Failed!', message: response['message']);
      }
    } catch (e) {
      // show some generic error to the user
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    }
  }
}
