import 'package:json_annotation/json_annotation.dart';

part 'booking.g.dart';

enum BookingStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum BookingPaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('paid')
  paid,
  @JsonValue('failed')
  failed,
  @JsonValue('refunded')
  refunded,
}

@JsonSerializable()
class Booking {
  final String uuid;
  final String propertyUuid;
  final String propertyTitle;
  final String propertyAddress;
  final String? propertyImageUrl;
  final String tenantUuid;
  final String tenantName;
  final String tenantEmail;
  final String ownerUuid;
  final String ownerName;
  final String ownerEmail;
  final int nights;
  final double totalAmount;
  final BookingStatus status;
  final BookingPaymentStatus paymentStatus;
  final DateTime checkinDate;
  final DateTime checkoutDate;
  final String? notes;
  final String? rejectionReason;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final DateTime? confirmedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  const Booking({
    required this.uuid,
    required this.propertyUuid,
    required this.propertyTitle,
    required this.propertyAddress,
    this.propertyImageUrl,
    required this.tenantUuid,
    required this.tenantName,
    required this.tenantEmail,
    required this.ownerUuid,
    required this.ownerName,
    required this.ownerEmail,
    required this.nights,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.checkinDate,
    required this.checkoutDate,
    this.notes,
    this.rejectionReason,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
    this.acceptedAt,
    this.rejectedAt,
    this.confirmedAt,
    this.completedAt,
    this.cancelledAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);

  Booking copyWith({
    String? uuid,
    String? propertyUuid,
    String? propertyTitle,
    String? propertyAddress,
    String? propertyImageUrl,
    String? tenantUuid,
    String? tenantName,
    String? tenantEmail,
    String? ownerUuid,
    String? ownerName,
    String? ownerEmail,
    int? nights,
    double? totalAmount,
    BookingStatus? status,
    BookingPaymentStatus? paymentStatus,
    DateTime? checkinDate,
    DateTime? checkoutDate,
    String? notes,
    String? rejectionReason,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acceptedAt,
    DateTime? rejectedAt,
    DateTime? confirmedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
  }) {
    return Booking(
      uuid: uuid ?? this.uuid,
      propertyUuid: propertyUuid ?? this.propertyUuid,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      propertyAddress: propertyAddress ?? this.propertyAddress,
      propertyImageUrl: propertyImageUrl ?? this.propertyImageUrl,
      tenantUuid: tenantUuid ?? this.tenantUuid,
      tenantName: tenantName ?? this.tenantName,
      tenantEmail: tenantEmail ?? this.tenantEmail,
      ownerUuid: ownerUuid ?? this.ownerUuid,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      nights: nights ?? this.nights,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      checkinDate: checkinDate ?? this.checkinDate,
      checkoutDate: checkoutDate ?? this.checkoutDate,
      notes: notes ?? this.notes,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }

  // Status checks
  bool get isPending => status == BookingStatus.pending;
  bool get isAccepted => status == BookingStatus.accepted;
  bool get isRejected => status == BookingStatus.rejected;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCompleted => status == BookingStatus.completed;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isActive => isAccepted || isConfirmed;
  bool get isFinished => isCompleted || isCancelled;
  bool get canBeAccepted => isPending;
  bool get canBeRejected => isPending;
  bool get canBeCompleted => isConfirmed;
  bool get canBeCancelled => isPending || isAccepted || isConfirmed;

  // Payment status checks
  bool get isPaymentPending => paymentStatus == BookingPaymentStatus.pending;
  bool get isPaymentPaid => paymentStatus == BookingPaymentStatus.paid;
  bool get isPaymentFailed => paymentStatus == BookingPaymentStatus.failed;
  bool get isPaymentRefunded => paymentStatus == BookingPaymentStatus.refunded;

  // Date checks
  bool get isUpcoming => checkinDate.isAfter(DateTime.now());
  bool get isOngoing => DateTime.now().isAfter(checkinDate) && DateTime.now().isBefore(checkoutDate);
  bool get isPast => checkoutDate.isBefore(DateTime.now());

  // Amount formatting
  String get totalAmountDisplay => 'LYD ${totalAmount.toStringAsFixed(2)}';
  String get amountPerNightDisplay => 'LYD ${(totalAmount / nights).toStringAsFixed(2)}/night';

  // Duration display
  String get durationDisplay => nights == 1 ? '1 night' : '$nights nights';

  // Notes and reasons
  bool get hasNotes => notes != null && notes!.isNotEmpty;
  bool get hasRejectionReason => rejectionReason != null && rejectionReason!.isNotEmpty;
  bool get hasCancellationReason => cancellationReason != null && cancellationReason!.isNotEmpty;

  @override
  String toString() {
    return 'Booking(uuid: $uuid, property: $propertyTitle, status: $status, nights: $nights)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Booking &&
        other.uuid == uuid &&
        other.propertyUuid == propertyUuid &&
        other.propertyTitle == propertyTitle &&
        other.propertyAddress == propertyAddress &&
        other.propertyImageUrl == propertyImageUrl &&
        other.tenantUuid == tenantUuid &&
        other.tenantName == tenantName &&
        other.tenantEmail == tenantEmail &&
        other.ownerUuid == ownerUuid &&
        other.ownerName == ownerName &&
        other.ownerEmail == ownerEmail &&
        other.nights == nights &&
        other.totalAmount == totalAmount &&
        other.status == status &&
        other.paymentStatus == paymentStatus &&
        other.checkinDate == checkinDate &&
        other.checkoutDate == checkoutDate &&
        other.notes == notes &&
        other.rejectionReason == rejectionReason &&
        other.cancellationReason == cancellationReason &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.acceptedAt == acceptedAt &&
        other.rejectedAt == rejectedAt &&
        other.confirmedAt == confirmedAt &&
        other.completedAt == completedAt &&
        other.cancelledAt == cancelledAt;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        propertyUuid.hashCode ^
        propertyTitle.hashCode ^
        propertyAddress.hashCode ^
        propertyImageUrl.hashCode ^
        tenantUuid.hashCode ^
        tenantName.hashCode ^
        tenantEmail.hashCode ^
        ownerUuid.hashCode ^
        ownerName.hashCode ^
        ownerEmail.hashCode ^
        nights.hashCode ^
        totalAmount.hashCode ^
        status.hashCode ^
        paymentStatus.hashCode ^
        checkinDate.hashCode ^
        checkoutDate.hashCode ^
        notes.hashCode ^
        rejectionReason.hashCode ^
        cancellationReason.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        acceptedAt.hashCode ^
        rejectedAt.hashCode ^
        confirmedAt.hashCode ^
        completedAt.hashCode ^
        cancelledAt.hashCode;
  }
}
