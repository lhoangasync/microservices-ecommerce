class ProductAttributeModel {
  String? name;
  final List<String>? values;

  ProductAttributeModel({this.name, this.values});

  // from json
  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    return ProductAttributeModel(
      name: json['name'] ?? '',
      values: List<String>.from(json['values'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'values': values};
  }
}
