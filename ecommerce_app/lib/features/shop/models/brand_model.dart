class BrandModel {
  String id;
  String name;
  String image;
  String description;
  bool? isFeature;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;

  BrandModel({
    required this.id,
    required this.name,
    required this.description,
    this.isFeature,
    required this.image,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  static BrandModel empty() => BrandModel(
    id: '',
    name: '',
    description: '',
    image: '',
    isFeature: false,
    createdBy: '',
    updatedBy: '',
    createdAt: '',
    updatedAt: '',
  );

  // From json
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      isFeature: json['isFeature'] ?? false,
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  // To json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'isFeature': isFeature,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
