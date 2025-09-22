import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

enum TransactionType {
  @JsonValue('topup')
  topup,
  @JsonValue('withdrawal')
  withdrawal,
  @JsonValue('payment')
  payment,
  @JsonValue('refund')
  refund,
  @JsonValue('adjustment')
  adjustment,
}

enum TransactionStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('cancelled')
  cancelled,
}

enum TransactionMethod {
  @JsonValue('card')
  card,
  @JsonValue('bank_transfer')
  bankTransfer,
  @JsonValue('wallet')
  wallet,
  @JsonValue('admin')
  admin,
}

@JsonSerializable()
class Transaction {
  final String uuid;
  final String walletUuid;
  final TransactionType type;
  final TransactionStatus status;
  final TransactionMethod method;
  final double amount;
  final String currency;
  final String? idempotencyKey;
  final String? bookingUuid;
  final String? notes;
  final Map<String, dynamic>? meta;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? failedAt;

  const Transaction({
    required this.uuid,
    required this.walletUuid,
    required this.type,
    required this.status,
    required this.method,
    required this.amount,
    required this.currency,
    this.idempotencyKey,
    this.bookingUuid,
    this.notes,
    this.meta,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.failedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  Transaction copyWith({
    String? uuid,
    String? walletUuid,
    TransactionType? type,
    TransactionStatus? status,
    TransactionMethod? method,
    double? amount,
    String? currency,
    String? idempotencyKey,
    String? bookingUuid,
    String? notes,
    Map<String, dynamic>? meta,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    DateTime? failedAt,
  }) {
    return Transaction(
      uuid: uuid ?? this.uuid,
      walletUuid: walletUuid ?? this.walletUuid,
      type: type ?? this.type,
      status: status ?? this.status,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      bookingUuid: bookingUuid ?? this.bookingUuid,
      notes: notes ?? this.notes,
      meta: meta ?? this.meta,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      failedAt: failedAt ?? this.failedAt,
    );
  }

  // Status checks
  bool get isPending => status == TransactionStatus.pending;
  bool get isCompleted => status == TransactionStatus.completed;
  bool get isFailed => status == TransactionStatus.failed;
  bool get isCancelled => status == TransactionStatus.cancelled;

  // Type checks
  bool get isTopup => type == TransactionType.topup;
  bool get isWithdrawal => type == TransactionType.withdrawal;
  bool get isPayment => type == TransactionType.payment;
  bool get isRefund => type == TransactionType.refund;
  bool get isAdjustment => type == TransactionType.adjustment;

  // Method checks
  bool get isCardPayment => method == TransactionMethod.card;
  bool get isBankTransfer => method == TransactionMethod.bankTransfer;
  bool get isWalletTransfer => method == TransactionMethod.wallet;
  bool get isAdminAdjustment => method == TransactionMethod.admin;

  // Amount formatting
  String get amountDisplay => '$currency ${amount.toStringAsFixed(2)}';
  String get signedAmountDisplay {
    final sign = isTopup || isRefund ? '+' : '-';
    return '$sign$currency ${amount.toStringAsFixed(2)}';
  }

  // Meta data helpers
  String? get adminNote => meta?['admin_note'] as String?;
  String? get userNote => meta?['note'] as String?;
  bool get hasMeta => meta != null && meta!.isNotEmpty;

  // Notes
  bool get hasNotes => notes != null && notes!.isNotEmpty;

  @override
  String toString() {
    return 'Transaction(uuid: $uuid, type: $type, status: $status, amount: $amountDisplay)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction &&
        other.uuid == uuid &&
        other.walletUuid == walletUuid &&
        other.type == type &&
        other.status == status &&
        other.method == method &&
        other.amount == amount &&
        other.currency == currency &&
        other.idempotencyKey == idempotencyKey &&
        other.bookingUuid == bookingUuid &&
        other.notes == notes &&
        other.meta == meta &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.completedAt == completedAt &&
        other.failedAt == failedAt;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        walletUuid.hashCode ^
        type.hashCode ^
        status.hashCode ^
        method.hashCode ^
        amount.hashCode ^
        currency.hashCode ^
        idempotencyKey.hashCode ^
        bookingUuid.hashCode ^
        notes.hashCode ^
        meta.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        completedAt.hashCode ^
        failedAt.hashCode;
  }
}
