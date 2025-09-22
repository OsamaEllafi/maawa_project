// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
  uuid: json['uuid'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$PropertyTypeEnumMap, json['type']),
  address: json['address'] as String,
  pricePerNight: (json['pricePerNight'] as num).toDouble(),
  capacity: (json['capacity'] as num).toInt(),
  amenities: (json['amenities'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  checkinTime: json['checkinTime'] as String,
  checkoutTime: json['checkoutTime'] as String,
  status: $enumDecode(_$PropertyStatusEnumMap, json['status']),
  rejectionReason: json['rejectionReason'] as String?,
  media: (json['media'] as List<dynamic>)
      .map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  ownerUuid: json['ownerUuid'] as String,
  ownerName: json['ownerName'] as String,
  averageRating: (json['averageRating'] as num?)?.toDouble(),
  reviewCount: (json['reviewCount'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  publishedAt: json['publishedAt'] == null
      ? null
      : DateTime.parse(json['publishedAt'] as String),
);

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'title': instance.title,
  'description': instance.description,
  'type': _$PropertyTypeEnumMap[instance.type]!,
  'address': instance.address,
  'pricePerNight': instance.pricePerNight,
  'capacity': instance.capacity,
  'amenities': instance.amenities,
  'checkinTime': instance.checkinTime,
  'checkoutTime': instance.checkoutTime,
  'status': _$PropertyStatusEnumMap[instance.status]!,
  'rejectionReason': instance.rejectionReason,
  'media': instance.media,
  'ownerUuid': instance.ownerUuid,
  'ownerName': instance.ownerName,
  'averageRating': instance.averageRating,
  'reviewCount': instance.reviewCount,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'publishedAt': instance.publishedAt?.toIso8601String(),
};

const _$PropertyTypeEnumMap = {
  PropertyType.villa: 'villa',
  PropertyType.apartment: 'apartment',
  PropertyType.house: 'house',
  PropertyType.room: 'room',
  PropertyType.studio: 'studio',
};

const _$PropertyStatusEnumMap = {
  PropertyStatus.draft: 'draft',
  PropertyStatus.pending: 'pending',
  PropertyStatus.published: 'published',
  PropertyStatus.rejected: 'rejected',
  PropertyStatus.unpublished: 'unpublished',
};
