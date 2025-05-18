import 'package:ecommerce_app/data/repositories/products/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utils/formatters/formatter.dart';
import 'package:ecommerce_app/utils/popups/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final isLoadMoreLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> allProducts = <ProductModel>[].obs;

  // Pagination control
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalElements = 1.obs;
  final int pageSize = 4;

  @override
  void onInit() {
    fetchAllProducts();
    super.onInit();
  }

  Future<List<ProductModel>> listAllProducts(int size) async {
    try {
      // fetch products
      final response = await productRepository.getAllProducts(
        page: currentPage.value,
        size: size,
      );

      final products = response.data;

      if (kDebugMode) {
        print(">>>>>CHECK: $products");
      }
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
      return [];
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      isLoading.value = true;

      // fetch products
      final response = await productRepository.getAllProducts(
        page: currentPage.value,
        size: pageSize,
      );

      // asign products
      allProducts.assignAll(response.data);

      // update pagination info
      totalPages.value = response.totalPages;

      // update total element info
      totalElements.value = response.totalElements;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    for (var variation in product.variants) {
      double priceToConsider =
          variation.salePrice > 0.0 ? variation.salePrice : variation.price;

      // update smallest and largest price
      if (priceToConsider < smallestPrice) {
        smallestPrice = priceToConsider;
      }

      if (priceToConsider > largestPrice) {
        largestPrice = priceToConsider;
      }
    }

    if (smallestPrice.isEqual(largestPrice)) {
      return largestPrice.toString();
    } else {
      return '${TFormatter.formatVND(smallestPrice)} - ${TFormatter.formatVND(largestPrice)}';
    }
  }

  // calculate discount percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  // check product stock status
  String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }
}
