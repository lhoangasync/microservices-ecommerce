import 'package:ecommerce_app/data/repositories/products/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:get/get.dart';

class AllProductsController extends GetxController {
  static AllProductsController get instance => Get.find();

  final repository = ProductRepository.instance;
  final RxString selectedSortOption = 'Name'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  void sortProducts(String sortOptions) {
    selectedSortOption.value = sortOptions;

    switch (sortOptions) {
      case 'Name':
        products.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Higher Price':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Lower Price':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Newest':
        products.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'Sale':
        products.sort((a, b) {
          if (b.salePrice > 0) {
            return b.salePrice.compareTo(a.salePrice);
          } else if (a.salePrice > 0) {
            return -1;
          } else {
            return -1;
          }
        });
        break;
      default:
        products.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  void assignProducts(List<ProductModel> products) {
    this.products.assignAll(products);
    sortProducts('Name');
  }
}
