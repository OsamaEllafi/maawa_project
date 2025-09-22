import 'entities/user.dart';
import 'entities/profile.dart';
import 'entities/kyc.dart';

abstract class UserRepository {
  // Profile management
  Future<User> getCurrentUser();
  Future<User> updateProfile(Profile profile);
  Future<String> uploadAvatar(String filePath);
  
  // KYC management
  Future<KYC> submitKYC({
    required String fullName,
    required String idNumber,
    required String iban,
  });
  
  Future<KYC?> getKYC();
  
  // Admin operations
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
  
  Future<void> verifyKYC(String userUuid, String notes);
  Future<void> rejectKYC(String userUuid, String notes);
}
