// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
  uuid: json['uuid'] as String,
  bookingUuid: json['bookingUuid'] as String,
  reviewerUuid: json['reviewerUuid'] as String,
  reviewerName: json['reviewerName'] as String,
  reviewerAvatar: json['reviewerAvatar'] as String?,
  revieweeUuid: json['revieweeUuid'] as String,
  revieweeName: json['revieweeName'] as String,
  revieweeAvatar: json['revieweeAvatar'] as String?,
  rating: (json['rating'] as num).toInt(),
  text: json['text'] as String,
  isHidden: json['isHidden'] as bool,
  hideReason: json['hideReason'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  hiddenAt: json['hiddenAt'] == null
      ? null
      : DateTime.parse(json['hiddenAt'] as String),
);

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'bookingUuid': instance.bookingUuid,
  'reviewerUuid': instance.reviewerUuid,
  'reviewerName': instance.reviewerName,
  'reviewerAvatar': instance.reviewerAvatar,
  'revieweeUuid': instance.revieweeUuid,
  'revieweeName': instance.revieweeName,
  'revieweeAvatar': instance.revieweeAvatar,
  'rating': instance.rating,
  'text': instance.text,
  'isHidden': instance.isHidden,
  'hideReason': instance.hideReason,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'hiddenAt': instance.hiddenAt?.toIso8601String(),
};
