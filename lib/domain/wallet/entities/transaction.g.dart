// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  uuid: json['uuid'] as String,
  walletUuid: json['walletUuid'] as String,
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
  method: $enumDecode(_$TransactionMethodEnumMap, json['method']),
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  idempotencyKey: json['idempotencyKey'] as String?,
  bookingUuid: json['bookingUuid'] as String?,
  notes: json['notes'] as String?,
  meta: json['meta'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  failedAt: json['failedAt'] == null
      ? null
      : DateTime.parse(json['failedAt'] as String),
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'walletUuid': instance.walletUuid,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'method': _$TransactionMethodEnumMap[instance.method]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'idempotencyKey': instance.idempotencyKey,
      'bookingUuid': instance.bookingUuid,
      'notes': instance.notes,
      'meta': instance.meta,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'failedAt': instance.failedAt?.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.topup: 'topup',
  TransactionType.withdrawal: 'withdrawal',
  TransactionType.payment: 'payment',
  TransactionType.refund: 'refund',
  TransactionType.adjustment: 'adjustment',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.completed: 'completed',
  TransactionStatus.failed: 'failed',
  TransactionStatus.cancelled: 'cancelled',
};

const _$TransactionMethodEnumMap = {
  TransactionMethod.card: 'card',
  TransactionMethod.bankTransfer: 'bank_transfer',
  TransactionMethod.wallet: 'wallet',
  TransactionMethod.admin: 'admin',
};
