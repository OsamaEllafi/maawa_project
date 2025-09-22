import '../../domain/admin/admin_repository.dart';
import '../../domain/user/entities/user.dart';
import '../../domain/properties/entities/property.dart';
import '../../domain/bookings/entities/booking.dart';
import '../../domain/reviews/entities/review.dart';
import '../../domain/wallet/entities/transaction.dart';
import '../../domain/admin/entities/mock_email.dart';
import 'admin_api.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminApi _adminApi;

  AdminRepositoryImpl(this._adminApi);

  @override
  Future<List<User>> getUsers({
    int page = 1,
    int perPage = 20,
    String? search,
    String? role,
    String? status,
  }) async {
    return await _adminApi.getUsers(
      page: page,
      perPage: perPage,
      search: search,
      role: role,
      status: status,
    );
  }

  @override
  Future<User> promoteToOwner(String userUuid) async {
    return await _adminApi.promoteToOwner(userUuid);
  }

  @override
  Future<User> demoteToTenant(String userUuid) async {
    return await _adminApi.demoteToTenant(userUuid);
  }

  @override
  Future<User> lockUser(String userUuid, String reason) async {
    return await _adminApi.lockUser(userUuid, reason);
  }

  @override
  Future<User> unlockUser(String userUuid) async {
    return await _adminApi.unlockUser(userUuid);
  }

  @override
  Future<void> verifyKYC(String userUuid, String notes) async {
    await _adminApi.verifyKYC(userUuid, notes);
  }

  @override
  Future<void> rejectKYC(String userUuid, String notes) async {
    await _adminApi.rejectKYC(userUuid, notes);
  }

  @override
  Future<List<Property>> getPendingProperties({
    int page = 1,
    int perPage = 20,
  }) async {
    return await _adminApi.getPendingProperties(
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<void> approveProperty(String propertyUuid) async {
    await _adminApi.approveProperty(propertyUuid);
  }

  @override
  Future<void> rejectProperty(String propertyUuid, String reason) async {
    await _adminApi.rejectProperty(propertyUuid, reason);
  }

  @override
  Future<void> unpublishProperty(String propertyUuid) async {
    await _adminApi.unpublishProperty(propertyUuid);
  }

  @override
  Future<void> cancelBooking(String bookingUuid, String reason) async {
    await _adminApi.cancelBooking(bookingUuid, reason);
  }

  @override
  Future<void> hideReview(String reviewUuid, String reason) async {
    await _adminApi.hideReview(reviewUuid, reason);
  }

  @override
  Future<void> unhideReview(String reviewUuid, String reason) async {
    await _adminApi.unhideReview(reviewUuid, reason);
  }

  @override
  Future<Transaction> adjustUserWallet({
    required String userUuid,
    required double amount,
    required String reason,
    required String idempotencyKey,
    Map<String, dynamic>? meta,
  }) async {
    return await _adminApi.adjustUserWallet(
      userUuid: userUuid,
      amount: amount,
      reason: reason,
      idempotencyKey: idempotencyKey,
      meta: meta,
    );
  }

  @override
  Future<List<MockEmail>> getMockEmails({
    int page = 1,
    int perPage = 20,
    String? user,
    String? type,
  }) async {
    return await _adminApi.getMockEmails(
      page: page,
      perPage: perPage,
      user: user,
      type: type,
    );
  }

  @override
  Future<MockEmail> getMockEmailDetails(String mockEmailUuid) async {
    return await _adminApi.getMockEmailDetails(mockEmailUuid);
  }

  @override
  Future<List<MockEmail>> getMockEmailsForUser(String userUuid) async {
    return await _adminApi.getMockEmailsForUser(userUuid);
  }

  @override
  Future<Map<String, dynamic>> getMockEmailStatistics() async {
    return await _adminApi.getMockEmailStatistics();
  }
}
