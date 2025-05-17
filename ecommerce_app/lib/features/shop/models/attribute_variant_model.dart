class AttributeVariantModel {
  String name;
  String value;

  AttributeVariantModel({required this.name, required this.value});

  static AttributeVariantModel empty() =>
      AttributeVariantModel(name: '', value: '');

  factory AttributeVariantModel.fromJson(Map<String, dynamic> json) {
    return AttributeVariantModel(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}
