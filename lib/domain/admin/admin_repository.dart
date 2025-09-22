import '../user/entities/user.dart';
import '../properties/entities/property.dart';
import '../bookings/entities/booking.dart';
import '../reviews/entities/review.dart';
import '../wallet/entities/transaction.dart';
import 'entities/mock_email.dart';

abstract class AdminRepository {
  // User management
  Future<List<User>> getUsers({
    int page = 1,
    int perPage = 20,
    String? search,
    String? role,
    String? status,
  });

  Future<User> promoteToOwner(String userUuid);
  Future<User> demoteToTenant(String userUuid);
  Future<User> lockUser(String userUuid, String reason);
  Future<User> unlockUser(String userUuid);

  // KYC management
  Future<void> verifyKYC(String userUuid, String notes);
  Future<void> rejectKYC(String userUuid, String notes);

  // Property management
  Future<List<Property>> getPendingProperties({
    int page = 1,
    int perPage = 20,
  });

  Future<void> approveProperty(String propertyUuid);
  Future<void> rejectProperty(String propertyUuid, String reason);
  Future<void> unpublishProperty(String propertyUuid);

  // Booking management
  Future<void> cancelBooking(String bookingUuid, String reason);

  // Review management
  Future<void> hideReview(String reviewUuid, String reason);
  Future<void> unhideReview(String reviewUuid, String reason);

  // Wallet management
  Future<Transaction> adjustUserWallet({
    required String userUuid,
    required double amount,
    required String reason,
    required String idempotencyKey,
    Map<String, dynamic>? meta,
  });

  // Mock emails
  Future<List<MockEmail>> getMockEmails({
    int page = 1,
    int perPage = 20,
    String? user,
    String? type,
  });

  Future<MockEmail> getMockEmailDetails(String mockEmailUuid);

  Future<List<MockEmail>> getMockEmailsForUser(String userUuid);

  Future<Map<String, dynamic>> getMockEmailStatistics();
}
