import 'package:get/get.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find();

  // variables
  final carousalCurrentIndex = 0.obs;

  // update page navigational dots
  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }
}
