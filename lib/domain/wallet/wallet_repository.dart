import 'entities/wallet.dart';
import 'entities/transaction.dart';

abstract class WalletRepository {
  // Wallet info
  Future<Wallet> getWalletInfo();

  // Transactions
  Future<List<Transaction>> getTransactions({
    int page = 1,
    int perPage = 20,
    String? type,
    String? status,
  });

  // Top-up operations
  Future<Transaction> topUpWallet({
    required double amount,
    required String method,
    required String idempotencyKey,
    String? bookingUuid,
    Map<String, dynamic>? meta,
  });

  // Withdrawal operations
  Future<Transaction> withdrawFromWallet({
    required double amount,
    required String method,
    required String idempotencyKey,
    Map<String, dynamic>? meta,
  });

  // Admin operations
  Future<Transaction> adjustUserWallet({
    required String userUuid,
    required double amount,
    required String reason,
    required String idempotencyKey,
    Map<String, dynamic>? meta,
  });
}
