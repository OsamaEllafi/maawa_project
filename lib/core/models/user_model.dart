enum UserRole { admin, owner, tenant }

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? avatar;
  final DateTime createdAt;
  final bool isVerified;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatar,
    required this.createdAt,
    this.isVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
      ),
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['createdAt']),
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? avatar,
    DateTime? createdAt,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
