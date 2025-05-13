class PermissionModel {
  final String id;
  final String name;
  final String apiPath;
  final String method;
  final String module;

  PermissionModel({
    required this.id,
    required this.name,
    required this.apiPath,
    required this.method,
    required this.module,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      apiPath: json['apiPath'] ?? '',
      method: json['method'] ?? '',
      module: json['module'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'apiPath': apiPath,
      'method': method,
      'module': module,
    };
  }

  static PermissionModel empty() {
    return PermissionModel(
      id: '',
      name: '',
      apiPath: '',
      method: '',
      module: '',
    );
  }
}
