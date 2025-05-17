import 'package:ecommerce_app/data/api/page_response_model.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/utils/http/http_client.dart';
import 'package:get/get.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();
  Future<PageResponse<BrandModel>> getAllBrands({
    required int page,
    required int size,
  }) async {
    try {
      final response = await THttpHelper.get(
        'brand/brands/get-all?page=$page&size=$size',
      );

      print("--- check Brands response: $response");

      if (response['code'] == 200) {
        final pageData = response['data']['data'];
        final categoryList = pageData['data'] as List<dynamic>;

        return PageResponse<BrandModel>(
          currentPage: pageData['currentPage'] ?? 1,
          totalPages: pageData['totalPages'] ?? 1,
          pageSize: pageData['pageSize'] ?? size,
          totalElements: pageData['totalElements'] ?? 0,
          data: categoryList.map((item) => BrandModel.fromJson(item)).toList(),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch categories');
      }
    } catch (e) {
      print('Error in getAllBrands: $e');
      rethrow;
    }
  }

  // get brands for category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      final response = await THttpHelper.get(
        'product/products/brands-in-category/$categoryId',
      );

      if (response['code'] == 200) {
        final brandJson = response['data']['data'] as List<dynamic>;
        List<BrandModel> allBrands =
            brandJson.map((item) => BrandModel.fromJson(item)).toList();

        print("---- check brands for category: $allBrands");

        return allBrands.length > 2 ? allBrands.sublist(0, 2) : allBrands;
      } else {
        throw Exception(
          response['message'] ?? 'Failed to fetch brands for category',
        );
      }
    } catch (e) {
      print('Error in getAllBrands: $e');
      rethrow;
    }
  }
}
