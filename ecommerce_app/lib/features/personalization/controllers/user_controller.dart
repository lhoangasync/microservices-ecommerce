import 'package:ecommerce_app/data/repositories/user/user_repostitory.dart';
import 'package:ecommerce_app/features/admin/admin_page.dart';
import 'package:ecommerce_app/features/personalization/models/user_model.dart';
import 'package:ecommerce_app/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final isUploadingAvatar = false.obs;

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.getMyAccount();
      this.user(user);

      if (user.role.name == "SUPER_ADMIN") {
        Get.offAll(() => AdminPage());
      }
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  // upload profile image
  Future<void> uploadAvatar() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 600,
        maxWidth: 600,
      );

      if (image != null) {
        isUploadingAvatar.value = true;

        final UserModel updatedUser = await userRepository.uploadAvatar(image);

        user.value = updatedUser;
        user.refresh();

        // show success message
        TLoaders.successSnackBar(
          title: 'Congratulations!',
          message: 'Your image has been updated!',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'On Snap', message: e.toString());
    } finally {
      isUploadingAvatar.value = false;
    }
  }
}
