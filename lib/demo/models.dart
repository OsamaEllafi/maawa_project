// User Models
enum UserRole { admin, owner, tenant }

enum KycStatus { pending, verified, rejected }

class DemoUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? avatar;
  final String phone;
  final DateTime joinDate;
  final bool isVerified;
  final KycStatus kycStatus;

  const DemoUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    required this.phone,
    required this.joinDate,
    required this.isVerified,
    required this.kycStatus,
  });
}

// Property Models
enum PropertyType { apartment, villa, studio, penthouse, townhouse }

enum PropertyStatus { draft, pending, published, rejected }

class DemoLocation {
  final String address;
  final String city;
  final String state;
  final String country;
  final double latitude;
  final double longitude;

  const DemoLocation({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
  });
}

class DemoProperty {
  final String id;
  final String title;
  final String description;
  final PropertyType type;
  final String ownerId;
  final List<String> images;
  final double pricePerNight;
  final String currency;
  final DemoLocation location;
  final List<String> amenities;
  final int capacity;
  final int bedrooms;
  final int bathrooms;
  final double rating;
  final int reviewCount;
  final PropertyStatus status;
  final DateTime createdAt;

  const DemoProperty({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.ownerId,
    required this.images,
    required this.pricePerNight,
    required this.currency,
    required this.location,
    required this.amenities,
    required this.capacity,
    required this.bedrooms,
    required this.bathrooms,
    required this.rating,
    required this.reviewCount,
    required this.status,
    required this.createdAt,
  });
}

// Booking Models
enum BookingStatus {
  requested,
  pendingPayment,
  confirmed,
  completed,
  cancelled,
  expired,
}

class DemoBooking {
  final String id;
  final String propertyId;
  final String tenantId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalAmount;
  final String currency;
  final BookingStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final DateTime? paymentDueAt;

  const DemoBooking({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalAmount,
    required this.currency,
    required this.status,
    this.notes,
    required this.createdAt,
    this.confirmedAt,
    this.completedAt,
    this.cancelledAt,
    this.paymentDueAt,
  });

  int get nights => checkOut.difference(checkIn).inDays;
}

// Review Models
class DemoReview {
  final String id;
  final String propertyId;
  final String bookingId;
  final String userId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const DemoReview({
    required this.id,
    required this.propertyId,
    required this.bookingId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}

// Wallet Models
enum TransactionType { topup, withdrawal, payment, earning, adjustment }

enum TransactionStatus { pending, completed, failed, cancelled }

class DemoTransaction {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String currency;
  final String description;
  final TransactionStatus status;
  final String? relatedBookingId;
  final DateTime createdAt;
  final DateTime? completedAt;

  const DemoTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.description,
    required this.status,
    this.relatedBookingId,
    required this.createdAt,
    this.completedAt,
  });
}

// Notification Models
enum NotificationType { booking, payment, system, property }

class DemoNotification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;

  const DemoNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });
}

// Helper Extensions
extension PropertyTypeExtension on PropertyType {
  String get displayName {
    switch (this) {
      case PropertyType.apartment:
        return 'Apartment';
      case PropertyType.villa:
        return 'Villa';
      case PropertyType.studio:
        return 'Studio';
      case PropertyType.penthouse:
        return 'Penthouse';
      case PropertyType.townhouse:
        return 'Townhouse';
    }
  }

  String get pluralName {
    switch (this) {
      case PropertyType.apartment:
        return 'Apartments';
      case PropertyType.villa:
        return 'Villas';
      case PropertyType.studio:
        return 'Studios';
      case PropertyType.penthouse:
        return 'Penthouses';
      case PropertyType.townhouse:
        return 'Townhouses';
    }
  }
}

extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.requested:
        return 'Requested';
      case BookingStatus.pendingPayment:
        return 'Pending Payment';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.expired:
        return 'Expired';
    }
  }
}

extension PropertyStatusExtension on PropertyStatus {
  String get displayName {
    switch (this) {
      case PropertyStatus.draft:
        return 'Draft';
      case PropertyStatus.pending:
        return 'Pending';
      case PropertyStatus.published:
        return 'Published';
      case PropertyStatus.rejected:
        return 'Rejected';
    }
  }
}

extension TransactionTypeExtension on TransactionType {
  String get displayName {
    switch (this) {
      case TransactionType.topup:
        return 'Top-up';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.payment:
        return 'Payment';
      case TransactionType.earning:
        return 'Earning';
      case TransactionType.adjustment:
        return 'Adjustment';
    }
  }
}
