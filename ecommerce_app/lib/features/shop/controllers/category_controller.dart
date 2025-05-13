import 'package:ecommerce_app/data/repositories/categories/categories_repository.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final categoryRepository = Get.put(CategoriesRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  // Pagination control
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int pageSize = 10;

  @override
  void onInit() {
    fetchAllCategories();
    super.onInit();
  }

  // Load category data
  Future<void> fetchAllCategories() async {
    try {
      // Show loader while loading categories
      isLoading.value = true;

      // fetch categories
      final response = await categoryRepository.getAllCategories(
        page: currentPage.value,
        size: pageSize,
      );

      print("--- check category response: $response");
      // update categories list
      allCategories.assignAll(response.data);

      // Update pagination info
      totalPages.value = response.totalPages;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    } finally {
      // Remove loader
      isLoading.value = false;
    }
  }
}
