import 'role_model.dart';

class UserModel {
  final String id;
  final String email;
  final String username;
  String imageUrl;
  String phone;
  String firstName;
  String lastName;
  final RoleModel role;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.imageUrl,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? imageUrl,
    String? phone,
    String? firstName,
    String? lastName,
    RoleModel? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      phone: json['phone'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: RoleModel.fromJson(json['role'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'imageUrl': imageUrl,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.toJson(),
    };
  }

  String get fullName => '$firstName $lastName';

  /// Tạo một user rỗng
  static UserModel empty() => UserModel(
    id: '',
    email: '',
    username: '',
    imageUrl: '',
    phone: '',
    firstName: '',
    lastName: '',
    role: RoleModel.empty(),
  );
}
