import 'package:ecommerce_app/data/api/page_response_model.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:get/get.dart';

import '../../../utils/http/http_client.dart';

class CategoriesRepository extends GetxController {
  static CategoriesRepository get instance => Get.find();

  /// Get all categories with pagination
  Future<PageResponse<CategoryModel>> getAllCategories({
    required int page,
    required int size,
  }) async {
    try {
      final response = await THttpHelper.get(
        'category/categories/get-all?page=$page&size=$size',
      );

      print("--- check category response: $response");

      if (response['code'] == 200) {
        final pageData = response['data']['data'];
        final categoryList = pageData['data'] as List<dynamic>;

        return PageResponse<CategoryModel>(
          currentPage: pageData['currentPage'] ?? 1,
          totalPages: pageData['totalPages'] ?? 1,
          pageSize: pageData['pageSize'] ?? size,
          totalElements: pageData['totalElements'] ?? 0,
          data:
              categoryList.map((item) => CategoryModel.fromJson(item)).toList(),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch categories');
      }
    } catch (e) {
      print('Error in getAllCategories: $e');
      rethrow;
    }
  }
}
