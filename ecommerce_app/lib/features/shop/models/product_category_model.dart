class ProductCategoryModel {
  final String productId;
  final String categoryId;

  ProductCategoryModel({required this.productId, required this.categoryId});

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'categoryId': categoryId};
  }

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      productId: json['productId'] ?? '',
      categoryId: json['categoryId'] ?? '',
    );
  }
}
