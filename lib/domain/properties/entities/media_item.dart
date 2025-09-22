import 'package:json_annotation/json_annotation.dart';

part 'media_item.g.dart';

enum MediaType {
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
}

@JsonSerializable()
class MediaItem {
  final int id;
  final String url;
  final String? thumbnailUrl;
  final MediaType type;
  final String? filename;
  final int? fileSize;
  final String? mimeType;
  final int sortIndex;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MediaItem({
    required this.id,
    required this.url,
    this.thumbnailUrl,
    required this.type,
    this.filename,
    this.fileSize,
    this.mimeType,
    required this.sortIndex,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) => _$MediaItemFromJson(json);
  Map<String, dynamic> toJson() => _$MediaItemToJson(this);

  MediaItem copyWith({
    int? id,
    String? url,
    String? thumbnailUrl,
    MediaType? type,
    String? filename,
    int? fileSize,
    String? mimeType,
    int? sortIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MediaItem(
      id: id ?? this.id,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      type: type ?? this.type,
      filename: filename ?? this.filename,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      sortIndex: sortIndex ?? this.sortIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isImage => type == MediaType.image;
  bool get isVideo => type == MediaType.video;
  bool get hasThumbnail => thumbnailUrl != null && thumbnailUrl!.isNotEmpty;
  String get displayUrl => hasThumbnail ? thumbnailUrl! : url;
  String get fileSizeDisplay {
    if (fileSize == null) return 'Unknown size';
    if (fileSize! < 1024) return '${fileSize}B';
    if (fileSize! < 1024 * 1024) return '${(fileSize! / 1024).toStringAsFixed(1)}KB';
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  @override
  String toString() {
    return 'MediaItem(id: $id, url: $url, type: $type, sortIndex: $sortIndex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MediaItem &&
        other.id == id &&
        other.url == url &&
        other.thumbnailUrl == thumbnailUrl &&
        other.type == type &&
        other.filename == filename &&
        other.fileSize == fileSize &&
        other.mimeType == mimeType &&
        other.sortIndex == sortIndex &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        url.hashCode ^
        thumbnailUrl.hashCode ^
        type.hashCode ^
        filename.hashCode ^
        fileSize.hashCode ^
        mimeType.hashCode ^
        sortIndex.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
