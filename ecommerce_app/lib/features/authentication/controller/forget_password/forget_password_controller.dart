import 'package:ecommerce_app/features/authentication/controller/signup/verify_email_controller.dart';
import 'package:ecommerce_app/features/authentication/screens/signup/verify_email.dart';
import 'package:ecommerce_app/utils/constants/image_strings.dart';
import 'package:ecommerce_app/utils/helpers/network_manager.dart';
import 'package:ecommerce_app/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  Future<void> submitForgetPasswordForm() async {
    final userEmail = email.text.trim();

    try {
      // Show loading
      TFullScreenLoader.openLoadingDialog(
        'Sending OTP to your $userEmail',
        TImages.docerAnimation,
      );

      // Validate form
      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'No Internet',
          message: 'Please check your connection.',
        );
        return;
      }

      // Init controller if needed
      if (!Get.isRegistered<VerifyEmailController>()) {
        Get.put(VerifyEmailController());
      } else {
        VerifyEmailController.instance.clearOTPFields();
      }

      // send email for reset password screen
      VerifyEmailController.instance.setEmail(userEmail);

      // Send OTP
      final isSent = await VerifyEmailController.instance.resendOTP(userEmail);

      TFullScreenLoader.stopLoading();

      if (isSent) {
        Get.off(
          () => VerifyEmailScreen(email: userEmail, isForgetPassword: true),
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
