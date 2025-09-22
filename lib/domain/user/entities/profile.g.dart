// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  phone: json['phone'] as String?,
  locale: json['locale'] as String?,
  timezone: json['timezone'] as String?,
  dateOfBirth: json['dateOfBirth'] == null
      ? null
      : DateTime.parse(json['dateOfBirth'] as String),
  gender: json['gender'] as String?,
  bio: json['bio'] as String?,
  preferences: json['preferences'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'phone': instance.phone,
  'locale': instance.locale,
  'timezone': instance.timezone,
  'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
  'gender': instance.gender,
  'bio': instance.bio,
  'preferences': instance.preferences,
};
