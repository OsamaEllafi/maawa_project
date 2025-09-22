import '../../core/errors/error_mapper.dart';
import '../../domain/wallet/entities/wallet.dart';
import '../../domain/wallet/entities/transaction.dart';
import '../network/dio_client.dart';

class WalletApi {
  final DioClient _dioClient;

  WalletApi(this._dioClient);

  // Wallet info
  Future<Wallet> getWalletInfo() async {
    try {
      final response = await _dioClient.get('/wallet');
      final data = response.data['data'] ?? response.data;
      return Wallet.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Transactions
  Future<List<Transaction>> getTransactions({
    int page = 1,
    int perPage = 20,
    String? type,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'per_page': perPage};

      if (type != null && type.isNotEmpty) {
        queryParams['type'] = type;
      }
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await _dioClient.get(
        '/wallet/transactions',
        queryParameters: queryParams,
      );
      final data = response.data['data'] ?? response.data;

      if (data is List) {
        return data.map((json) => Transaction.fromJson(json)).toList();
      } else if (data['transactions'] is List) {
        return (data['transactions'] as List)
            .map((json) => Transaction.fromJson(json))
            .toList();
      }

      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Top-up operations
  Future<Transaction> topUpWallet({
    required double amount,
    required String method,
    required String idempotencyKey,
    String? bookingUuid,
    Map<String, dynamic>? meta,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'amount': amount,
        'method': method,
        'idempotency_key': idempotencyKey,
      };

      if (bookingUuid != null) {
        requestData['booking_uuid'] = bookingUuid;
      }
      if (meta != null) {
        requestData['meta'] = meta;
      }

      final response = await _dioClient.post(
        '/wallet/topup',
        data: requestData,
      );
      final data = response.data['data'] ?? response.data;
      return Transaction.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Withdrawal operations
  Future<Transaction> withdrawFromWallet({
    required double amount,
    required String method,
    required String idempotencyKey,
    Map<String, dynamic>? meta,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'amount': amount,
        'method': method,
        'idempotency_key': idempotencyKey,
      };

      if (meta != null) {
        requestData['meta'] = meta;
      }

      final response = await _dioClient.post(
        '/wallet/withdraw',
        data: requestData,
      );
      final data = response.data['data'] ?? response.data;
      return Transaction.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Admin operations
  Future<Transaction> adjustUserWallet({
    required String userUuid,
    required double amount,
    required String reason,
    required String idempotencyKey,
    Map<String, dynamic>? meta,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'amount': amount,
        'reason': reason,
        'idempotency_key': idempotencyKey,
      };

      if (meta != null) {
        requestData['meta'] = meta;
      }

      final response = await _dioClient.post(
        '/admin/wallet/$userUuid/adjust',
        data: requestData,
      );
      final data = response.data['data'] ?? response.data;
      return Transaction.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }
}
