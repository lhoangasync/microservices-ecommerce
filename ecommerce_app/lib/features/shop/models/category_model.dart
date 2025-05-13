class CategoryModel {
  String id;
  String name;
  String description;
  String image;
  String createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // Constructor rỗng (empty object)
  static CategoryModel empty() => CategoryModel(
    id: '',
    name: '',
    description: '',
    image: '',
    createdBy: '',
    updatedBy: '',
    createdAt: '',
    updatedAt: '',
  );

  // From JSON factory
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  // To JSON for sending to API if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
