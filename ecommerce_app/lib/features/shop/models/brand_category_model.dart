class BrandCategoryModel {
  final String brandId;
  final String categoryId;

  BrandCategoryModel({required this.brandId, required this.categoryId});

  Map<String, dynamic> toJson() {
    return {'brandId': brandId, 'categoryId': categoryId};
  }

  factory BrandCategoryModel.fromJson(Map<String, dynamic> json) {
    return BrandCategoryModel(
      brandId: json['brandId'] ?? '',
      categoryId: json['categoryId'] ?? '',
    );
  }
}
