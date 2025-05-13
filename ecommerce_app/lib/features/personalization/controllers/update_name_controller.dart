import 'package:ecommerce_app/data/repositories/user/user_repostitory.dart';
import 'package:ecommerce_app/features/personalization/controllers/user_controller.dart';
import 'package:ecommerce_app/utils/constants/image_strings.dart';
import 'package:ecommerce_app/utils/helpers/network_manager.dart';
import 'package:ecommerce_app/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();

  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());

  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  // init user data when Chang Name Screen appears
  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  Future<void> initializeNames() async {
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }

  Future<void> updateUserName() async {
    try {
      // Start loading
      TFullScreenLoader.openLoadingDialog(
        'We are updating your information...',
        TImages.docerAnimation,
      );

      // check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // form validation
      if (!updateUserNameFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // update user's first name & last name in database
      Map<String, dynamic> data = {
        'id': userController.user.value.id,
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
      };

      final response = await userRepository.updateUser(data);

      if (kDebugMode) {
        print("-----------------------Update User response: $response");
      }

      // update the Rx user value
      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastName.text.trim();
      userController.user.refresh();

      // remove loader
      TFullScreenLoader.stopLoading();

      // show success message
      TLoaders.successSnackBar(
        title: 'Congratulations!',
        message: 'Your name has been updated!',
      );

      // Move to previous screen.
      Get.close(1);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'On Snap', message: e.toString());
    }
  }
}
