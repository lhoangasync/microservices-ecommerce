import 'package:ecommerce_app/features/shop/models/attribute_variant_model.dart';

class ProductVariationModel {
  String variantId;
  String variantName;
  String image;
  String description;
  double price;
  double salePrice;
  int quantity;
  String stockStatus;
  List<AttributeVariantModel> attributeVariant;

  ProductVariationModel({
    required this.variantId,
    required this.variantName,
    required this.image,
    required this.description,
    required this.price,
    required this.salePrice,
    required this.quantity,
    required this.stockStatus,
    required this.attributeVariant,
  });

  static ProductVariationModel empty() => ProductVariationModel(
    variantId: '',
    variantName: '',
    image: '',
    description: '',
    price: 0.0,
    salePrice: 0.0,
    quantity: 0,
    stockStatus: '',
    attributeVariant: [],
  );

  factory ProductVariationModel.fromJson(Map<String, dynamic> json) {
    return ProductVariationModel(
      variantId: json['variantId'] ?? '',
      variantName: json['variantName'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      salePrice: (json['salePrice'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      stockStatus: json['stockStatus'] ?? '',
      attributeVariant:
          (json['attributeVariant'] as List<dynamic>?)
              ?.map((e) => AttributeVariantModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'variantName': variantName,
      'image': image,
      'description': description,
      'price': price,
      'salePrice': salePrice,
      'quantity': quantity,
      'stockStatus': stockStatus,
      'attributeVariant': attributeVariant.map((e) => e.toJson()).toList(),
    };
  }
}
