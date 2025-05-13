import 'package:ecommerce_app/common/widgets/loaders/animation_loader.dart';
import 'package:ecommerce_app/utils/constants/colors.dart';
import 'package:ecommerce_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TFullScreenLoader {
  /// Open a full-screen loading dialog with a given text and animation.
  /// This method doesn't return anything.
  ///
  /// Parameters:
  ///   - text: The text to be displayed in the loading dialog.
  ///   - animation: The Lottie animation to be shown.
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context:
          Get.overlayContext!, // Use Get.overlayContext for overlay dialogs
      barrierDismissible:
          false, // The dialog can't be dismissed by tapping outside it
      builder:
          (_) => PopScope(
            canPop: false, // Disable popping with the back button
            child: Container(
              color:
                  THelperFunctions.isDarkMode(Get.context!)
                      ? TColors.dark
                      : TColors.white,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TAnimationLoaderWidget(text: text, animation: animation),
                ],
              ),
            ),
          ),
    );
  }

  /// Stop the currently open loading dialog.
  /// This method doesn't return anything.
  static stopLoading() {
    Navigator.of(
      Get.overlayContext!,
    ).pop(); // Close the dialog using the Navigator
  }
}
