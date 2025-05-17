import 'package:ecommerce_app/data/repositories/brands/brand_repository.dart';
import 'package:ecommerce_app/data/repositories/products/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:get/get.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  RxBool isLoading = true.obs;
  final RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final RxList<BrandModel> featuredBrands = <BrandModel>[].obs;
  final brandRepository = Get.put(BrandRepository());

  // Pagination control
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int pageSize = 1000;

  @override
  void onInit() {
    fetchAllBrands();
    super.onInit();
  }

  // load brands
  Future<void> fetchAllBrands() async {
    try {
      // show loader while loading brands
      isLoading.value = true;

      final brands = await brandRepository.getAllBrands(
        page: currentPage.value,
        size: pageSize,
      );

      allBrands.assignAll(brands.data);

      featuredBrands.assignAll(
        allBrands.where((brand) => brand.isFeature ?? false).take(4),
      );

      totalPages.value = brands.totalPages;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // get brands for category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      final brands = await brandRepository.getBrandsForCategory(categoryId);
      return brands;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oops!', message: e.toString());
      return [];
    }
  }

  // get brand specific products from data
  Future<List<ProductModel>> getBrandProducts({
    required String brandId,
    int limit = -1,
  }) async {
    try {
      final productsPage = await ProductRepository.instance.getProductsByBrand(
        page: currentPage.value,
        size: limit == -1 ? pageSize : limit,
        brandId: brandId,
      );

      return productsPage.data;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oops!', message: e.toString());
      return [];
    }
  }
}
