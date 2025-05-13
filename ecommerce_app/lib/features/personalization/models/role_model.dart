import 'package:ecommerce_app/features/personalization/models/permission_model.dart';

class RoleModel {
  final String id;
  final String name;
  final String description;
  final bool active;
  final List<PermissionModel> permissions;

  RoleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
    required this.permissions,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    var permissionList =
        (json['permissions'] as List?)
            ?.map((perm) => PermissionModel.fromJson(perm))
            .toList() ??
        [];

    return RoleModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      active: json['active'] ?? false,
      permissions: permissionList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'active': active,
      'permissions': permissions.map((e) => e.toJson()).toList(),
    };
  }

  static RoleModel empty() => RoleModel(
    id: '',
    name: '',
    description: '',
    active: false,
    permissions: [],
  );
}
