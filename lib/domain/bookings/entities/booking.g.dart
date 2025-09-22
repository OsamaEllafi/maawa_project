// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
  uuid: json['uuid'] as String,
  propertyUuid: json['propertyUuid'] as String,
  propertyTitle: json['propertyTitle'] as String,
  propertyAddress: json['propertyAddress'] as String,
  propertyImageUrl: json['propertyImageUrl'] as String?,
  tenantUuid: json['tenantUuid'] as String,
  tenantName: json['tenantName'] as String,
  tenantEmail: json['tenantEmail'] as String,
  ownerUuid: json['ownerUuid'] as String,
  ownerName: json['ownerName'] as String,
  ownerEmail: json['ownerEmail'] as String,
  nights: (json['nights'] as num).toInt(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  status: $enumDecode(_$BookingStatusEnumMap, json['status']),
  paymentStatus: $enumDecode(
    _$BookingPaymentStatusEnumMap,
    json['paymentStatus'],
  ),
  checkinDate: DateTime.parse(json['checkinDate'] as String),
  checkoutDate: DateTime.parse(json['checkoutDate'] as String),
  notes: json['notes'] as String?,
  rejectionReason: json['rejectionReason'] as String?,
  cancellationReason: json['cancellationReason'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  acceptedAt: json['acceptedAt'] == null
      ? null
      : DateTime.parse(json['acceptedAt'] as String),
  rejectedAt: json['rejectedAt'] == null
      ? null
      : DateTime.parse(json['rejectedAt'] as String),
  confirmedAt: json['confirmedAt'] == null
      ? null
      : DateTime.parse(json['confirmedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
);

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'propertyUuid': instance.propertyUuid,
  'propertyTitle': instance.propertyTitle,
  'propertyAddress': instance.propertyAddress,
  'propertyImageUrl': instance.propertyImageUrl,
  'tenantUuid': instance.tenantUuid,
  'tenantName': instance.tenantName,
  'tenantEmail': instance.tenantEmail,
  'ownerUuid': instance.ownerUuid,
  'ownerName': instance.ownerName,
  'ownerEmail': instance.ownerEmail,
  'nights': instance.nights,
  'totalAmount': instance.totalAmount,
  'status': _$BookingStatusEnumMap[instance.status]!,
  'paymentStatus': _$BookingPaymentStatusEnumMap[instance.paymentStatus]!,
  'checkinDate': instance.checkinDate.toIso8601String(),
  'checkoutDate': instance.checkoutDate.toIso8601String(),
  'notes': instance.notes,
  'rejectionReason': instance.rejectionReason,
  'cancellationReason': instance.cancellationReason,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'acceptedAt': instance.acceptedAt?.toIso8601String(),
  'rejectedAt': instance.rejectedAt?.toIso8601String(),
  'confirmedAt': instance.confirmedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'cancelledAt': instance.cancelledAt?.toIso8601String(),
};

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.accepted: 'accepted',
  BookingStatus.rejected: 'rejected',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
};

const _$BookingPaymentStatusEnumMap = {
  BookingPaymentStatus.pending: 'pending',
  BookingPaymentStatus.paid: 'paid',
  BookingPaymentStatus.failed: 'failed',
  BookingPaymentStatus.refunded: 'refunded',
};
