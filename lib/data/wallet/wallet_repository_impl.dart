import '../../domain/wallet/wallet_repository.dart';
import '../../domain/wallet/entities/wallet.dart';
import '../../domain/wallet/entities/transaction.dart';
import 'wallet_api.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletApi _walletApi;

  WalletRepositoryImpl(this._walletApi);

  @override
  Future<Wallet> getWalletInfo() async {
    return await _walletApi.getWalletInfo();
  }

  @override
  Future<List<Transaction>> getTransactions({
    int page = 1,
    int perPage = 20,
    String? type,
    String? status,
  }) async {
    return await _walletApi.getTransactions(
      page: page,
      perPage: perPage,
      type: type,
      status: status,
    );
  }

  @override
  Future<Transaction> topUpWallet({
    required double amount,
    required String method,
    required String idempotencyKey,
    String? bookingUuid,
    Map<String, dynamic>? meta,
  }) async {
    return await _walletApi.topUpWallet(
      amount: amount,
      method: method,
      idempotencyKey: idempotencyKey,
      bookingUuid: bookingUuid,
      meta: meta,
    );
  }

  @override
  Future<Transaction> withdrawFromWallet({
    required double amount,
    required String method,
    required String idempotencyKey,
    Map<String, dynamic>? meta,
  }) async {
    return await _walletApi.withdrawFromWallet(
      amount: amount,
      method: method,
      idempotencyKey: idempotencyKey,
      meta: meta,
    );
  }

  @override
  Future<Transaction> adjustUserWallet({
    required String userUuid,
    required double amount,
    required String reason,
    required String idempotencyKey,
    Map<String, dynamic>? meta,
  }) async {
    return await _walletApi.adjustUserWallet(
      userUuid: userUuid,
      amount: amount,
      reason: reason,
      idempotencyKey: idempotencyKey,
      meta: meta,
    );
  }
}
