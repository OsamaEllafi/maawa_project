// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String?,
  tokenType: json['tokenType'] as String? ?? 'Bearer',
  expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 0,
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'tokenType': instance.tokenType,
  'expiresIn': instance.expiresIn,
  'expiresAt': instance.expiresAt?.toIso8601String(),
};
