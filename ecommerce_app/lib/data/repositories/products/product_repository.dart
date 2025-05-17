import 'package:ecommerce_app/data/api/page_response_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utils/http/http_client.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  Future<PageResponse<ProductModel>> getAllProducts({
    required int page,
    required int size,
  }) async {
    try {
      final response = await THttpHelper.get(
        'product/products/get-all?page=$page&size=$size',
      );

      // print("----Check product response: $response");

      if (response['code'] == 200) {
        final pageData = response['data']['data'];
        final productList = pageData['data'] as List<dynamic>;

        return PageResponse<ProductModel>(
          currentPage: pageData['currentPage'] ?? 1,
          totalPages: pageData['totalPages'] ?? 1,
          pageSize: pageData['pageSize'] ?? size,
          totalElements: pageData['totalElements'] ?? 0,
          data: productList.map((item) => ProductModel.fromJson(item)).toList(),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch products');
      }
    } catch (e) {
      print('Error in getAllCategories: $e');
      rethrow;
    }
  }

  Future<PageResponse<ProductModel>> getAllProductsByName({
    required int page,
    required int size,
  }) async {
    try {
      final response = await THttpHelper.get(
        'product/products/get-by-name?page=$page&size=$size',
      );

      print("----Check product by name response: $response");

      if (response['code'] == 200) {
        final pageData = response['data']['data'];
        final productList = pageData['data'] as List<dynamic>;

        return PageResponse<ProductModel>(
          currentPage: pageData['currentPage'] ?? 1,
          totalPages: pageData['totalPages'] ?? 1,
          pageSize: pageData['pageSize'] ?? size,
          totalElements: pageData['totalElements'] ?? 0,
          data: productList.map((item) => ProductModel.fromJson(item)).toList(),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch products');
      }
    } catch (e) {
      print('Error in getAllCategories: $e');
      rethrow;
    }
  }

  Future<PageResponse<ProductModel>> getAllProductsByPriceAsc({
    required int page,
    required int size,
  }) async {
    try {
      final response = await THttpHelper.get(
        'product/products/get-by-price-asc?page=$page&size=$size',
      );

      print("----Check product response (price asc): $response");

      if (response['code'] == 200) {
        final pageData = response['data']['data'];
        final productList = pageData['data'] as List<dynamic>;

        return PageResponse<ProductModel>(
          currentPage: pageData['currentPage'] ?? 1,
          totalPages: pageData['totalPages'] ?? 1,
          pageSize: pageData['pageSize'] ?? size,
          totalElements: pageData['totalElements'] ?? 0,
          data: productList.map((item) => ProductModel.fromJson(item)).toList(),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch products');
      }
    } catch (e) {
      print('Error in getAllProductsByPriceAsc: $e');
      rethrow;
    }
  }

  Future<PageResponse<ProductModel>> getAllProductsByPriceDesc({
    required int page,
    required int size,
  }) async {
    try {
      final response = await THttpHelper.get(
        'product/products/get-by-price-desc?page=$page&size=$size',
      );

      print("----Check product response (price desc): $response");

      if (response['code'] == 200) {
        final pageData = response['data']['data'];
        final productList = pageData['data'] as List<dynamic>;

        return PageResponse<ProductModel>(
          currentPage: pageData['currentPage'] ?? 1,
          totalPages: pageData['totalPages'] ?? 1,
          pageSize: pageData['pageSize'] ?? size,
          totalElements: pageData['totalElements'] ?? 0,
          data: productList.map((item) => ProductModel.fromJson(item)).toList(),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch products');
      }
    } catch (e) {
      print('Error in getAllProductsByPriceDesc: $e');
      rethrow;
    }
  }

  Future<PageResponse<ProductModel>> getAllProductsBySalePrice({
    required int page,
    required int size,
  }) async {
    try {
      final response = await THttpHelper.get(
        'product/products/get-by-salePrice?page=$page&size=$size',
      );

      print("----Check product response (sale price): $response");

      if (response['code'] == 200) {
        final pageData = response['data']['data'];
        final productList = pageData['data'] as List<dynamic>;

        return PageResponse<ProductModel>(
          currentPage: pageData['currentPage'] ?? 1,
          totalPages: pageData['totalPages'] ?? 1,
          pageSize: pageData['pageSize'] ?? size,
          totalElements: pageData['totalElements'] ?? 0,
          data: productList.map((item) => ProductModel.fromJson(item)).toList(),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch products');
      }
    } catch (e) {
      print('Error in getAllProductsBySalePrice: $e');
      rethrow;
    }
  }

  Future<PageResponse<ProductModel>> getAllProductsByNewest({
    required int page,
    required int size,
  }) async {
    try {
      final response = await THttpHelper.get(
        'product/products/get-by-newest?page=$page&size=$size',
      );

      print("----Check product response (newest): $response");

      if (response['code'] == 200) {
        final pageData = response['data']['data'];
        final productList = pageData['data'] as List<dynamic>;

        return PageResponse<ProductModel>(
          currentPage: pageData['currentPage'] ?? 1,
          totalPages: pageData['totalPages'] ?? 1,
          pageSize: pageData['pageSize'] ?? size,
          totalElements: pageData['totalElements'] ?? 0,
          data: productList.map((item) => ProductModel.fromJson(item)).toList(),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch products');
      }
    } catch (e) {
      print('Error in getAllProductsByNewest: $e');
      rethrow;
    }
  }

  Future<PageResponse<ProductModel>> getProductsByBrand({
    required int page,
    required int size,
    required String brandId,
  }) async {
    try {
      final response = await THttpHelper.get(
        'product/products/brand/$brandId?page=$page&size=$size',
      );

      print("--- check Products by Brand response: $response");

      if (response['code'] == 200) {
        final pageData = response['data']['data'];
        final productList = pageData['data'] as List<dynamic>;

        return PageResponse<ProductModel>(
          currentPage: pageData['currentPage'] ?? 1,
          totalPages: pageData['totalPages'] ?? 1,
          pageSize: pageData['pageSize'] ?? size,
          totalElements: pageData['totalElements'] ?? 0,
          data: productList.map((item) => ProductModel.fromJson(item)).toList(),
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch products');
      }
    } catch (e) {
      print('Error in getProductsByBrand: $e');
      rethrow;
    }
  }

  Future<PageResponse<ProductModel>> getProductsByCategory({
    required String categoryId,
    required int page,
    required int size,
  }) async {
    try {
      final response = await THttpHelper.get(
        'product/products/category/$categoryId?page=$page&size=$size',
      );

      print("--- check getProductsByCategory response: $response");

      if (response['code'] == 200) {
        final pageData = response['data']['data'];
        final productList = pageData['data'] as List<dynamic>;

        return PageResponse<ProductModel>(
          currentPage: pageData['currentPage'] ?? 1,
          totalPages: pageData['totalPages'] ?? 1,
          pageSize: pageData['pageSize'] ?? size,
          totalElements: pageData['totalElements'] ?? 0,
          data: productList.map((item) => ProductModel.fromJson(item)).toList(),
        );
      } else {
        throw Exception(
          response['message'] ?? 'Failed to fetch products by category',
        );
      }
    } catch (e) {
      print('Error in getProductsByCategory: $e');
      rethrow;
    }
  }

  Future<List<ProductModel>> getFavouriteProducts(
    List<String> productIds,
  ) async {
    try {
      if (productIds.isEmpty) return [];

      final response = await THttpHelper.post(
        'product/products/fetch-by-ids',
        productIds,
      );

      if (response['code'] == 200) {
        final productList = response['data']['data'] as List<dynamic>;
        return productList.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        throw Exception(
          response['message'] ?? 'Failed to fetch favourite products',
        );
      }
    } catch (e) {
      print('Error in getProductsByCategory: $e');
      rethrow;
    }
  }
}
