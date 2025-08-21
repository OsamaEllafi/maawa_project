import 'models.dart';

class DemoData {
  // Demo Users
  static final List<DemoUser> users = [
    DemoUser(
      id: 'admin-001',
      name: 'System Administrator',
      email: 'admin@maawa.ly',
      role: UserRole.admin,
      avatar:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      phone: '+218-91-234-5678',
      joinDate: DateTime(2024, 1, 1),
      isVerified: true,
      kycStatus: KycStatus.verified,
    ),
    DemoUser(
      id: 'owner-001',
      name: 'Ahmed Al-Mansouri',
      email: 'ahmed.owner@maawa.ly',
      role: UserRole.owner,
      avatar:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      phone: '+218-92-345-6789',
      joinDate: DateTime(2024, 2, 15),
      isVerified: true,
      kycStatus: KycStatus.verified,
    ),
    DemoUser(
      id: 'owner-002',
      name: 'Fatima Ben Ali',
      email: 'fatima.owner@maawa.ly',
      role: UserRole.owner,
      avatar:
          'https://images.unsplash.com/photo-1494790108755-2616b612b05b?w=150',
      phone: '+218-93-456-7890',
      joinDate: DateTime(2024, 3, 10),
      isVerified: true,
      kycStatus: KycStatus.pending,
    ),
    DemoUser(
      id: 'tenant-001',
      name: 'Omar Khalil',
      email: 'omar.tenant@maawa.ly',
      role: UserRole.tenant,
      avatar:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=150',
      phone: '+218-94-567-8901',
      joinDate: DateTime(2024, 4, 5),
      isVerified: true,
      kycStatus: KycStatus.verified,
    ),
    DemoUser(
      id: 'tenant-002',
      name: 'Aisha Mohamed',
      email: 'aisha.tenant@maawa.ly',
      role: UserRole.tenant,
      avatar:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      phone: '+218-95-678-9012',
      joinDate: DateTime(2024, 5, 20),
      isVerified: false,
      kycStatus: KycStatus.pending,
    ),
  ];

  // Demo Properties
  static final List<DemoProperty> properties = [
    DemoProperty(
      id: 'prop-001',
      title: 'Modern Apartment in Tripoli Marina',
      description:
          'Stunning 2-bedroom apartment with sea views in the heart of Tripoli Marina. Features modern amenities, balcony, and 24/7 security.',
      type: PropertyType.apartment,
      ownerId: 'owner-001',
      images: [
        'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800',
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
      ],
      pricePerNight: 150.0,
      currency: 'LYD',
      location: DemoLocation(
        address: 'Marina District, Tripoli',
        city: 'Tripoli',
        state: 'Tripoli',
        country: 'Libya',
        latitude: 32.8872,
        longitude: 13.1913,
      ),
      amenities: [
        'WiFi',
        'Air Conditioning',
        'Kitchen',
        'Balcony',
        'Security',
        'Parking',
      ],
      capacity: 4,
      bedrooms: 2,
      bathrooms: 2,
      rating: 4.8,
      reviewCount: 124,
      status: PropertyStatus.published,
      createdAt: DateTime(2024, 1, 15),
    ),
    DemoProperty(
      id: 'prop-002',
      title: 'Luxury Villa in Benghazi Hills',
      description:
          'Spacious 4-bedroom villa with private pool and garden. Perfect for families seeking comfort and privacy in Benghazi\'s premium location.',
      type: PropertyType.villa,
      ownerId: 'owner-001',
      images: [
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
      ],
      pricePerNight: 350.0,
      currency: 'LYD',
      location: DemoLocation(
        address: 'Al-Hadaiq District, Benghazi',
        city: 'Benghazi',
        state: 'Cyrenaica',
        country: 'Libya',
        latitude: 32.1313,
        longitude: 20.0985,
      ),
      amenities: [
        'WiFi',
        'Air Conditioning',
        'Private Pool',
        'Garden',
        'BBQ',
        'Parking',
        'Security',
      ],
      capacity: 8,
      bedrooms: 4,
      bathrooms: 3,
      rating: 4.9,
      reviewCount: 89,
      status: PropertyStatus.published,
      createdAt: DateTime(2024, 2, 1),
    ),
    DemoProperty(
      id: 'prop-003',
      title: 'Cozy Studio Near Misrata Beach',
      description:
          'Charming studio apartment just minutes from Misrata\'s beautiful coastline. Ideal for solo travelers or couples.',
      type: PropertyType.studio,
      ownerId: 'owner-002',
      images: [
        'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
      ],
      pricePerNight: 95.0,
      currency: 'LYD',
      location: DemoLocation(
        address: 'Coastal Road, Misrata',
        city: 'Misrata',
        state: 'Misrata',
        country: 'Libya',
        latitude: 32.3745,
        longitude: 15.0876,
      ),
      amenities: ['WiFi', 'Air Conditioning', 'Kitchen', 'Beach Access'],
      capacity: 2,
      bedrooms: 1,
      bathrooms: 1,
      rating: 4.6,
      reviewCount: 156,
      status: PropertyStatus.published,
      createdAt: DateTime(2024, 3, 5),
    ),
    DemoProperty(
      id: 'prop-004',
      title: 'Penthouse in Downtown Tripoli',
      description:
          'Luxurious penthouse with panoramic city views. Features premium finishes and rooftop terrace.',
      type: PropertyType.penthouse,
      ownerId: 'owner-002',
      images: [
        'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
        'https://images.unsplash.com/photo-1502672023488-70e25813eb80?w=800',
      ],
      pricePerNight: 450.0,
      currency: 'LYD',
      location: DemoLocation(
        address: 'Green Square, Tripoli',
        city: 'Tripoli',
        state: 'Tripoli',
        country: 'Libya',
        latitude: 32.8925,
        longitude: 13.1802,
      ),
      amenities: [
        'WiFi',
        'Air Conditioning',
        'Rooftop Terrace',
        'City View',
        'Concierge',
        'Gym',
      ],
      capacity: 6,
      bedrooms: 3,
      bathrooms: 2,
      rating: 4.7,
      reviewCount: 67,
      status: PropertyStatus.pending,
      createdAt: DateTime(2024, 4, 10),
    ),
  ];

  // Demo Bookings
  static final List<DemoBooking> bookings = [
    DemoBooking(
      id: 'book-001',
      propertyId: 'prop-001',
      tenantId: 'tenant-001',
      checkIn: DateTime.now().add(const Duration(days: 30)),
      checkOut: DateTime.now().add(const Duration(days: 33)),
      guests: 2,
      totalAmount: 450.0,
      currency: 'LYD',
      status: BookingStatus.confirmed,
      notes: 'Celebrating anniversary. Late check-in requested.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      confirmedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    DemoBooking(
      id: 'book-002',
      propertyId: 'prop-002',
      tenantId: 'tenant-002',
      checkIn: DateTime.now().add(const Duration(days: 15)),
      checkOut: DateTime.now().add(const Duration(days: 20)),
      guests: 6,
      totalAmount: 1750.0,
      currency: 'LYD',
      status: BookingStatus.pendingPayment,
      notes: 'Family vacation with children.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      paymentDueAt: DateTime.now().add(const Duration(minutes: 25)),
    ),
    DemoBooking(
      id: 'book-003',
      propertyId: 'prop-003',
      tenantId: 'tenant-001',
      checkIn: DateTime.now().subtract(const Duration(days: 10)),
      checkOut: DateTime.now().subtract(const Duration(days: 8)),
      guests: 1,
      totalAmount: 190.0,
      currency: 'LYD',
      status: BookingStatus.completed,
      notes: 'Business trip.',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      confirmedAt: DateTime.now().subtract(const Duration(days: 13)),
      completedAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    DemoBooking(
      id: 'book-004',
      propertyId: 'prop-001',
      tenantId: 'tenant-002',
      checkIn: DateTime.now().add(const Duration(days: 7)),
      checkOut: DateTime.now().add(const Duration(days: 10)),
      guests: 3,
      totalAmount: 450.0,
      currency: 'LYD',
      status: BookingStatus.requested,
      notes: 'Weekend getaway with friends.',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  // Demo Reviews
  static final List<DemoReview> reviews = [
    DemoReview(
      id: 'rev-001',
      propertyId: 'prop-001',
      bookingId: 'book-003',
      userId: 'tenant-001',
      rating: 5,
      comment:
          'Absolutely amazing stay! The apartment was spotless and the sea view was breathtaking. Ahmed was very responsive and helpful.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    DemoReview(
      id: 'rev-002',
      propertyId: 'prop-002',
      bookingId: 'book-001',
      userId: 'tenant-002',
      rating: 5,
      comment:
          'Perfect villa for our family vacation. Kids loved the pool and the location was ideal. Highly recommend!',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    DemoReview(
      id: 'rev-003',
      propertyId: 'prop-003',
      bookingId: 'book-002',
      userId: 'tenant-001',
      rating: 4,
      comment:
          'Great value for money. Clean, comfortable, and close to the beach. Only minor issue was WiFi speed.',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  // Demo Wallet Transactions
  static final List<DemoTransaction> transactions = [
    DemoTransaction(
      id: 'txn-001',
      userId: 'tenant-001',
      type: TransactionType.topup,
      amount: 500.0,
      currency: 'LYD',
      description: 'Wallet top-up via bank transfer',
      status: TransactionStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      completedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    DemoTransaction(
      id: 'txn-002',
      userId: 'tenant-001',
      type: TransactionType.payment,
      amount: -450.0,
      currency: 'LYD',
      description: 'Payment for booking #book-001',
      status: TransactionStatus.completed,
      relatedBookingId: 'book-001',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      completedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    DemoTransaction(
      id: 'txn-003',
      userId: 'owner-001',
      type: TransactionType.earning,
      amount: 405.0, // 450 - 10% platform fee
      currency: 'LYD',
      description: 'Earning from booking #book-001',
      status: TransactionStatus.completed,
      relatedBookingId: 'book-001',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    DemoTransaction(
      id: 'txn-004',
      userId: 'tenant-002',
      type: TransactionType.withdrawal,
      amount: -200.0,
      currency: 'LYD',
      description: 'Withdrawal to bank account',
      status: TransactionStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  // Demo Notifications
  static final List<DemoNotification> notifications = [
    DemoNotification(
      id: 'notif-001',
      userId: 'tenant-001',
      title: 'Booking Confirmed',
      message:
          'Your booking for Modern Apartment in Tripoli Marina has been confirmed.',
      type: NotificationType.booking,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    DemoNotification(
      id: 'notif-002',
      userId: 'owner-001',
      title: 'New Booking Request',
      message: 'You have a new booking request for your property.',
      type: NotificationType.booking,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    DemoNotification(
      id: 'notif-003',
      userId: 'tenant-002',
      title: 'Payment Reminder',
      message: 'Don\'t forget to complete your payment for upcoming booking.',
      type: NotificationType.payment,
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  // Helper methods to get filtered data
  static List<DemoProperty> getPropertiesByOwner(String ownerId) {
    return properties.where((p) => p.ownerId == ownerId).toList();
  }

  static List<DemoProperty> getPropertiesByStatus(PropertyStatus status) {
    return properties.where((p) => p.status == status).toList();
  }

  static List<DemoTransaction> getTransactionsByUser(String userId) {
    return transactions.where((t) => t.userId == userId).toList();
  }

  static List<DemoReview> getReviewsByProperty(String propertyId) {
    return reviews.where((r) => r.propertyId == propertyId).toList();
  }

  static List<DemoNotification> getNotificationsByUser(String userId) {
    return notifications.where((n) => n.userId == userId).toList();
  }

  static DemoUser? getUserById(String id) {
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  static DemoProperty? getPropertyById(String id) {
    try {
      return properties.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  static double getUserWalletBalance(String userId) {
    final userTransactions = getTransactionsByUser(userId);
    double balance = 0.0;

    for (final transaction in userTransactions) {
      if (transaction.status == TransactionStatus.completed) {
        balance += transaction.amount;
      }
    }

    return balance;
  }

  // Mutable list for dynamic bookings
  static final List<DemoBooking> _dynamicBookings = [];

  // Method to add a new booking
  static void addBooking(DemoBooking booking) {
    _dynamicBookings.add(booking);
  }

  // Method to get all bookings (including dynamic ones)
  static List<DemoBooking> getAllBookings() {
    return [...bookings, ..._dynamicBookings];
  }

  // Updated methods to use getAllBookings()
  static List<DemoBooking> getBookingsByTenant(String tenantId) {
    return getAllBookings().where((b) => b.tenantId == tenantId).toList();
  }

  static List<DemoBooking> getBookingsForUser(String userId) {
    return getAllBookings().where((b) => b.tenantId == userId).toList();
  }

  static List<DemoBooking> getBookingsByProperty(String propertyId) {
    return getAllBookings().where((b) => b.propertyId == propertyId).toList();
  }

  static List<DemoBooking> getBookingsByStatus(BookingStatus status) {
    return getAllBookings().where((b) => b.status == status).toList();
  }

  static DemoBooking? getBookingById(String bookingId) {
    try {
      return getAllBookings().firstWhere((b) => b.id == bookingId);
    } catch (e) {
      return null;
    }
  }
}
