import '../../domain/user/user_repository.dart';
import '../../domain/user/entities/user.dart';
import '../../domain/user/entities/profile.dart';
import '../../domain/user/entities/kyc.dart';
import 'user_api.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApi _userApi;

  UserRepositoryImpl(this._userApi);

  @override
  Future<User> getCurrentUser() async {
    return await _userApi.getCurrentUser();
  }

  @override
  Future<User> updateProfile(Profile profile) async {
    return await _userApi.updateProfile(profile);
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    return await _userApi.uploadAvatar(filePath);
  }

  @override
  Future<KYC> submitKYC({
    required String fullName,
    required String idNumber,
    required String iban,
  }) async {
    return await _userApi.submitKYC(
      fullName: fullName,
      idNumber: idNumber,
      iban: iban,
    );
  }

  @override
  Future<KYC?> getKYC() async {
    return await _userApi.getKYC();
  }

  @override
  Future<List<User>> getUsers({
    int page = 1,
    int perPage = 20,
    String? search,
    String? role,
    String? status,
  }) async {
    return await _userApi.getUsers(
      page: page,
      perPage: perPage,
      search: search,
      role: role,
      status: status,
    );
  }

  @override
  Future<User> promoteToOwner(String userUuid) async {
    return await _userApi.promoteToOwner(userUuid);
  }

  @override
  Future<User> demoteToTenant(String userUuid) async {
    return await _userApi.demoteToTenant(userUuid);
  }

  @override
  Future<User> lockUser(String userUuid, String reason) async {
    return await _userApi.lockUser(userUuid, reason);
  }

  @override
  Future<User> unlockUser(String userUuid) async {
    return await _userApi.unlockUser(userUuid);
  }

  @override
  Future<void> verifyKYC(String userUuid, String notes) async {
    await _userApi.verifyKYC(userUuid, notes);
  }

  @override
  Future<void> rejectKYC(String userUuid, String notes) async {
    await _userApi.rejectKYC(userUuid, notes);
  }
}
