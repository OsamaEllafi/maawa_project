// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KYC _$KYCFromJson(Map<String, dynamic> json) => KYC(
  uuid: json['uuid'] as String,
  fullName: json['fullName'] as String,
  idNumber: json['idNumber'] as String,
  iban: json['iban'] as String,
  status: $enumDecode(_$KYCStatusEnumMap, json['status']),
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  verifiedAt: json['verifiedAt'] == null
      ? null
      : DateTime.parse(json['verifiedAt'] as String),
  rejectedAt: json['rejectedAt'] == null
      ? null
      : DateTime.parse(json['rejectedAt'] as String),
);

Map<String, dynamic> _$KYCToJson(KYC instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'fullName': instance.fullName,
  'idNumber': instance.idNumber,
  'iban': instance.iban,
  'status': _$KYCStatusEnumMap[instance.status]!,
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'verifiedAt': instance.verifiedAt?.toIso8601String(),
  'rejectedAt': instance.rejectedAt?.toIso8601String(),
};

const _$KYCStatusEnumMap = {
  KYCStatus.pending: 'pending',
  KYCStatus.verified: 'verified',
  KYCStatus.rejected: 'rejected',
};
