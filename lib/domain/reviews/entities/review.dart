import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  final String uuid;
  final String bookingUuid;
  final String reviewerUuid;
  final String reviewerName;
  final String? reviewerAvatar;
  final String revieweeUuid;
  final String revieweeName;
  final String? revieweeAvatar;
  final int rating;
  final String text;
  final bool isHidden;
  final String? hideReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? hiddenAt;

  const Review({
    required this.uuid,
    required this.bookingUuid,
    required this.reviewerUuid,
    required this.reviewerName,
    this.reviewerAvatar,
    required this.revieweeUuid,
    required this.revieweeName,
    this.revieweeAvatar,
    required this.rating,
    required this.text,
    required this.isHidden,
    this.hideReason,
    required this.createdAt,
    required this.updatedAt,
    this.hiddenAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  Review copyWith({
    String? uuid,
    String? bookingUuid,
    String? reviewerUuid,
    String? reviewerName,
    String? reviewerAvatar,
    String? revieweeUuid,
    String? revieweeName,
    String? revieweeAvatar,
    int? rating,
    String? text,
    bool? isHidden,
    String? hideReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? hiddenAt,
  }) {
    return Review(
      uuid: uuid ?? this.uuid,
      bookingUuid: bookingUuid ?? this.bookingUuid,
      reviewerUuid: reviewerUuid ?? this.reviewerUuid,
      reviewerName: reviewerName ?? this.reviewerName,
      reviewerAvatar: reviewerAvatar ?? this.reviewerAvatar,
      revieweeUuid: revieweeUuid ?? this.revieweeUuid,
      revieweeName: revieweeName ?? this.revieweeName,
      revieweeAvatar: revieweeAvatar ?? this.revieweeAvatar,
      rating: rating ?? this.rating,
      text: text ?? this.text,
      isHidden: isHidden ?? this.isHidden,
      hideReason: hideReason ?? this.hideReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hiddenAt: hiddenAt ?? this.hiddenAt,
    );
  }

  // Rating helpers
  bool get isFiveStar => rating == 5;
  bool get isFourStar => rating == 4;
  bool get isThreeStar => rating == 3;
  bool get isTwoStar => rating == 2;
  bool get isOneStar => rating == 1;
  bool get isPositive => rating >= 4;
  bool get isNeutral => rating == 3;
  bool get isNegative => rating <= 2;

  // Avatar helpers
  bool get hasReviewerAvatar => reviewerAvatar != null && reviewerAvatar!.isNotEmpty;
  bool get hasRevieweeAvatar => revieweeAvatar != null && revieweeAvatar!.isNotEmpty;

  // Text helpers
  bool get hasText => text.isNotEmpty;
  String get shortText {
    if (text.length <= 100) return text;
    return '${text.substring(0, 100)}...';
  }

  // Hidden status
  bool get hasHideReason => hideReason != null && hideReason!.isNotEmpty;

  // Date helpers
  bool get isRecent => DateTime.now().difference(createdAt).inDays < 7;
  bool get isOld => DateTime.now().difference(createdAt).inDays > 30;

  @override
  String toString() {
    return 'Review(uuid: $uuid, rating: $rating, reviewer: $reviewerName, reviewee: $revieweeName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Review &&
        other.uuid == uuid &&
        other.bookingUuid == bookingUuid &&
        other.reviewerUuid == reviewerUuid &&
        other.reviewerName == reviewerName &&
        other.reviewerAvatar == reviewerAvatar &&
        other.revieweeUuid == revieweeUuid &&
        other.revieweeName == revieweeName &&
        other.revieweeAvatar == revieweeAvatar &&
        other.rating == rating &&
        other.text == text &&
        other.isHidden == isHidden &&
        other.hideReason == hideReason &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.hiddenAt == hiddenAt;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        bookingUuid.hashCode ^
        reviewerUuid.hashCode ^
        reviewerName.hashCode ^
        reviewerAvatar.hashCode ^
        revieweeUuid.hashCode ^
        revieweeName.hashCode ^
        revieweeAvatar.hashCode ^
        rating.hashCode ^
        text.hashCode ^
        isHidden.hashCode ^
        hideReason.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        hiddenAt.hashCode;
  }
}
