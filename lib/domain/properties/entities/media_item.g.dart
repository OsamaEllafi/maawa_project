// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaItem _$MediaItemFromJson(Map<String, dynamic> json) => MediaItem(
  id: (json['id'] as num).toInt(),
  url: json['url'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  type: $enumDecode(_$MediaTypeEnumMap, json['type']),
  filename: json['filename'] as String?,
  fileSize: (json['fileSize'] as num?)?.toInt(),
  mimeType: json['mimeType'] as String?,
  sortIndex: (json['sortIndex'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MediaItemToJson(MediaItem instance) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
  'thumbnailUrl': instance.thumbnailUrl,
  'type': _$MediaTypeEnumMap[instance.type]!,
  'filename': instance.filename,
  'fileSize': instance.fileSize,
  'mimeType': instance.mimeType,
  'sortIndex': instance.sortIndex,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$MediaTypeEnumMap = {MediaType.image: 'image', MediaType.video: 'video'};
