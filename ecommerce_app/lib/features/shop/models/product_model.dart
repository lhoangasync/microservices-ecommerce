import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/features/shop/models/product_attribute_model.dart';
import 'package:ecommerce_app/features/shop/models/product_variation_model.dart';

class ProductModel {
  String id;
  String userId;
  String name;
  String description;
  int quantity;
  List<String> image;
  String thumbnail;
  String status;
  double price;
  double salePrice;
  CategoryModel category;
  BrandModel brand;
  List<ProductAttributeModel> attributes;
  List<ProductVariationModel> variants;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;

  ProductModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.image,
    required this.thumbnail,
    required this.status,
    required this.price,
    required this.salePrice,
    required this.category,
    required this.brand,
    required this.attributes,
    required this.variants,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  static ProductModel empty() => ProductModel(
    id: '',
    userId: '',
    name: '',
    description: '',
    quantity: 0,
    image: [],
    thumbnail: '',
    status: '',
    price: 0.0,
    salePrice: 0.0,
    category: CategoryModel.empty(),
    brand: BrandModel.empty(),
    attributes: [],
    variants: [],
    createdBy: '',
    updatedBy: '',
    createdAt: '',
    updatedAt: '',
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 0,
      image: List<String>.from(json['image'] ?? []),
      thumbnail: json['thumbnail'] ?? '',
      status: json['status'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      salePrice: (json['salePrice'] ?? 0).toDouble(),
      category: CategoryModel.fromJson(json['category'] ?? {}),
      brand: BrandModel.fromJson(json['brand'] ?? {}),
      attributes:
          (json['attributes'] as List<dynamic>?)
              ?.map((e) => ProductAttributeModel.fromJson(e))
              .toList() ??
          [],
      variants:
          (json['variants'] as List<dynamic>?)
              ?.map((e) => ProductVariationModel.fromJson(e))
              .toList() ??
          [],
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'quantity': quantity,
      'image': image,
      'thumbnail': thumbnail,
      'status': status,
      'price': price,
      'salePrice': salePrice,
      'category': category.toJson(),
      'brand': brand.toJson(),
      'attributes': attributes.map((e) => e.toJson()).toList(),
      'variants': variants.map((e) => e.toJson()).toList(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
