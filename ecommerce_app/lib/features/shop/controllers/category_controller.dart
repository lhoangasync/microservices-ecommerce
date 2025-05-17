import 'package:ecommerce_app/data/repositories/categories/categories_repository.dart';
import 'package:ecommerce_app/data/repositories/products/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final categoryRepository = Get.put(CategoriesRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
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

      // update categories list
      allCategories.assignAll(response.data);

      featuredCategories.assignAll(
        allCategories.where((category) => category.isParent ?? false),
      );

      // Update pagination info
      totalPages.value = response.totalPages;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    } finally {
      // Remove loader
      isLoading.value = false;
    }
  }

  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final subCategogies = await categoryRepository.getSubCategories(
        categoryId,
      );
      return subCategogies;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
      return [];
    }
  }

  // get product by category
  Future<List<ProductModel>> getCategoryProducts({
    required String categoryId,
    int limit = 4,
  }) async {
    try {
      final products = await ProductRepository.instance.getProductsByCategory(
        categoryId: categoryId,
        page: currentPage.value,
        size: limit < 0 ? pageSize : limit,
      );
      return products.data;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
      return [];
    }
  }
}
