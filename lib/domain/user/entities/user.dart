import 'package:json_annotation/json_annotation.dart';
import 'profile.dart';
import 'kyc.dart';

part 'user.g.dart';

enum UserRole {
  @JsonValue('tenant')
  tenant,
  @JsonValue('owner')
  owner,
  @JsonValue('admin')
  admin,
}

enum UserStatus {
  @JsonValue('active')
  active,
  @JsonValue('locked')
  locked,
  @JsonValue('pending')
  pending,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String uuid;
  final String name;
  final String email;
  final UserRole role;
  final UserStatus status;
  final String? avatar;
  final Profile? profile;
  final KYC? kyc;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? emailVerifiedAt;

  const User({
    required this.uuid,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.avatar,
    this.profile,
    this.kyc,
    required this.createdAt,
    required this.updatedAt,
    this.emailVerifiedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle API response format differences
    final data = Map<String, dynamic>.from(json);

    // Map 'id' to 'uuid' if present
    if (data.containsKey('id') && !data.containsKey('uuid')) {
      data['uuid'] = data['id'];
    }

    // Set default role if missing (try to infer from email or other fields)
    if (!data.containsKey('role')) {
      final email = data['email'] as String? ?? '';
      if (email.contains('admin')) {
        data['role'] = 'admin';
      } else if (email.contains('owner')) {
        data['role'] = 'owner';
      } else {
        data['role'] = 'tenant'; // default
      }
    }

    return _$UserFromJson(data);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? uuid,
    String? name,
    String? email,
    UserRole? role,
    UserStatus? status,
    String? avatar,
    Profile? profile,
    KYC? kyc,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? emailVerifiedAt,
  }) {
    return User(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      profile: profile ?? this.profile,
      kyc: kyc ?? this.kyc,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
    );
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isOwner => role == UserRole.owner;
  bool get isTenant => role == UserRole.tenant;
  bool get isActive => status == UserStatus.active;
  bool get isLocked => status == UserStatus.locked;
  bool get isPending => status == UserStatus.pending;
  bool get isEmailVerified => emailVerifiedAt != null;
  bool get hasKYC => kyc != null;
  bool get hasProfile => profile != null;

  @override
  String toString() {
    return 'User(uuid: $uuid, name: $name, email: $email, role: $role, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.uuid == uuid &&
        other.name == name &&
        other.email == email &&
        other.role == role &&
        other.status == status &&
        other.avatar == avatar &&
        other.profile == profile &&
        other.kyc == kyc &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.emailVerifiedAt == emailVerifiedAt;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        role.hashCode ^
        status.hashCode ^
        avatar.hashCode ^
        profile.hashCode ^
        kyc.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        emailVerifiedAt.hashCode;
  }
}
