import 'package:json_annotation/json_annotation.dart';
import 'media_item.dart';

part 'property.g.dart';

enum PropertyType {
  @JsonValue('villa')
  villa,
  @JsonValue('apartment')
  apartment,
  @JsonValue('house')
  house,
  @JsonValue('room')
  room,
  @JsonValue('studio')
  studio,
}

enum PropertyStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('pending')
  pending,
  @JsonValue('published')
  published,
  @JsonValue('rejected')
  rejected,
  @JsonValue('unpublished')
  unpublished,
}

@JsonSerializable()
class Property {
  final String uuid;
  final String title;
  final String description;
  final PropertyType type;
  final String address;
  final double pricePerNight;
  final int capacity;
  final List<String> amenities;
  final String checkinTime;
  final String checkoutTime;
  final PropertyStatus status;
  final String? rejectionReason;
  final List<MediaItem> media;
  final String ownerUuid;
  final String ownerName;
  final double? averageRating;
  final int? reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;

  const Property({
    required this.uuid,
    required this.title,
    required this.description,
    required this.type,
    required this.address,
    required this.pricePerNight,
    required this.capacity,
    required this.amenities,
    required this.checkinTime,
    required this.checkoutTime,
    required this.status,
    this.rejectionReason,
    required this.media,
    required this.ownerUuid,
    required this.ownerName,
    this.averageRating,
    this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyToJson(this);

  Property copyWith({
    String? uuid,
    String? title,
    String? description,
    PropertyType? type,
    String? address,
    double? pricePerNight,
    int? capacity,
    List<String>? amenities,
    String? checkinTime,
    String? checkoutTime,
    PropertyStatus? status,
    String? rejectionReason,
    List<MediaItem>? media,
    String? ownerUuid,
    String? ownerName,
    double? averageRating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
  }) {
    return Property(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      address: address ?? this.address,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      capacity: capacity ?? this.capacity,
      amenities: amenities ?? this.amenities,
      checkinTime: checkinTime ?? this.checkinTime,
      checkoutTime: checkoutTime ?? this.checkoutTime,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      media: media ?? this.media,
      ownerUuid: ownerUuid ?? this.ownerUuid,
      ownerName: ownerName ?? this.ownerName,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  // Status checks
  bool get isDraft => status == PropertyStatus.draft;
  bool get isPending => status == PropertyStatus.pending;
  bool get isPublished => status == PropertyStatus.published;
  bool get isRejected => status == PropertyStatus.rejected;
  bool get isUnpublished => status == PropertyStatus.unpublished;
  bool get isPublic => isPublished;
  bool get canBeSubmitted => isDraft;
  bool get canBeEdited => isDraft || isRejected;
  bool get hasRejectionReason => rejectionReason != null && rejectionReason!.isNotEmpty;

  // Media checks
  bool get hasMedia => media.isNotEmpty;
  bool get hasMainImage => media.isNotEmpty;
  String? get mainImageUrl => hasMainImage ? media.first.url : null;

  // Rating checks
  bool get hasRating => averageRating != null && reviewCount != null && reviewCount! > 0;
  String get ratingDisplay => hasRating ? '${averageRating!.toStringAsFixed(1)} ($reviewCount)' : 'No reviews';

  // Price formatting
  String get priceDisplay => 'LYD ${pricePerNight.toStringAsFixed(2)}';
  String get pricePerNightDisplay => 'LYD ${pricePerNight.toStringAsFixed(2)}/night';

  // Amenities
  String get amenitiesDisplay => amenities.join(', ');

  @override
  String toString() {
    return 'Property(uuid: $uuid, title: $title, type: $type, status: $status, price: $pricePerNight)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Property &&
        other.uuid == uuid &&
        other.title == title &&
        other.description == description &&
        other.type == type &&
        other.address == address &&
        other.pricePerNight == pricePerNight &&
        other.capacity == capacity &&
        other.amenities == amenities &&
        other.checkinTime == checkinTime &&
        other.checkoutTime == checkoutTime &&
        other.status == status &&
        other.rejectionReason == rejectionReason &&
        other.media == media &&
        other.ownerUuid == ownerUuid &&
        other.ownerName == ownerName &&
        other.averageRating == averageRating &&
        other.reviewCount == reviewCount &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.publishedAt == publishedAt;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        title.hashCode ^
        description.hashCode ^
        type.hashCode ^
        address.hashCode ^
        pricePerNight.hashCode ^
        capacity.hashCode ^
        amenities.hashCode ^
        checkinTime.hashCode ^
        checkoutTime.hashCode ^
        status.hashCode ^
        rejectionReason.hashCode ^
        media.hashCode ^
        ownerUuid.hashCode ^
        ownerName.hashCode ^
        averageRating.hashCode ^
        reviewCount.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        publishedAt.hashCode;
  }
}
