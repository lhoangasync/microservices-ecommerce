import 'package:ecommerce_app/common/widgets/success_screen/success_screen.dart';
import 'package:ecommerce_app/features/authentication/screens/login/login.dart';
import 'package:ecommerce_app/features/authentication/screens/password_configuration/forget_password_form.dart';
import 'package:ecommerce_app/utils/constants/image_strings.dart';
import 'package:ecommerce_app/utils/constants/text_strings.dart';
import 'package:ecommerce_app/utils/helpers/network_manager.dart';
import 'package:ecommerce_app/utils/http/http_client.dart';
import 'package:ecommerce_app/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  final email = ''.obs;

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  RxBool isLoading = false.obs;

  String getVerificationCode() {
    return otpControllers.map((controller) => controller.text).join();
  }

  void handleOTPChange(String value, int index, BuildContext context) {
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  // Function VERIFY OTP
  Future<void> verifyOTP(String email, {bool isForgetPassword = false}) async {
    try {
      final otp = getVerificationCode();
      TFullScreenLoader.openLoadingDialog(
        'Verifying code...',
        TImages.docerAnimation,
      );

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'No Internet',
          message: 'Please check your connection.',
        );
        return;
      }

      final response = await THttpHelper.post('identity/auth/verify-otp', {
        "email": email,
        "otp": otp,
      });

      TFullScreenLoader.stopLoading();

      if (response['code'] == 200) {
        if (isForgetPassword == true) {
          Get.off(() => const RecoverPasswordScreen());
        } else {
          TLoaders.successSnackBar(
            title: 'Verified!',
            message: response['message'],
          );

          Get.to(
            () => SuccessScreen(
              image: TImages.staticSuccessIllustration,
              title: TTexts.yourAccountCreatedTitle,
              subTitle:
                  'Welcome to $email Ultimate Shopping Destination: Your Account is Created, Unleash the Joy of Seamless Online Shopping!',
              onPressed: () => Get.offAll(() => const LoginScreen()),
            ),
          );
        }
      } else {
        TLoaders.errorSnackBar(
          title: 'Invalid Code!',
          message: response['message'],
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Function RESEND OTP
  Future<bool> resendOTP(String email) async {
    try {
      isLoading.value = true;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(
          title: 'No Internet',
          message: 'Please check your connection.',
        );
        return false;
      }

      final response = await THttpHelper.post(
        'identity/auth/resend-otp?email=$email',
        {},
      );

      if (response['code'] == 200) {
        TLoaders.successSnackBar(
          title: 'OTP Sent!',
          message: response['message'],
        );
        return true;
      } else {
        TLoaders.errorSnackBar(
          title: 'Failed to resend',
          message: response['message'],
        );
        return false;
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearOTPFields() {
    for (final controller in otpControllers) {
      controller.clear();
    }
  }

  void setEmail(String value) {
    email.value = value;
  }
}
