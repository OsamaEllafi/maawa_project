// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  uuid: json['uuid'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  status: $enumDecode(_$UserStatusEnumMap, json['status']),
  avatar: json['avatar'] as String?,
  profile: json['profile'] == null
      ? null
      : Profile.fromJson(json['profile'] as Map<String, dynamic>),
  kyc: json['kyc'] == null
      ? null
      : KYC.fromJson(json['kyc'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  emailVerifiedAt: json['email_verified_at'] == null
      ? null
      : DateTime.parse(json['email_verified_at'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'email': instance.email,
  'role': _$UserRoleEnumMap[instance.role]!,
  'status': _$UserStatusEnumMap[instance.status]!,
  'avatar': instance.avatar,
  'profile': instance.profile,
  'kyc': instance.kyc,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
};

const _$UserRoleEnumMap = {
  UserRole.tenant: 'tenant',
  UserRole.owner: 'owner',
  UserRole.admin: 'admin',
};

const _$UserStatusEnumMap = {
  UserStatus.active: 'active',
  UserStatus.locked: 'locked',
  UserStatus.pending: 'pending',
};
