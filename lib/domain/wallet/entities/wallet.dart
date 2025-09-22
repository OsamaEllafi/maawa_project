import 'package:json_annotation/json_annotation.dart';

part 'wallet.g.dart';

@JsonSerializable()
class Wallet {
  final String uuid;
  final String userUuid;
  final double balance;
  final String currency;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Wallet({
    required this.uuid,
    required this.userUuid,
    required this.balance,
    required this.currency,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
  Map<String, dynamic> toJson() => _$WalletToJson(this);

  Wallet copyWith({
    String? uuid,
    String? userUuid,
    double? balance,
    String? currency,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Wallet(
      uuid: uuid ?? this.uuid,
      userUuid: userUuid ?? this.userUuid,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get balanceDisplay => '$currency ${balance.toStringAsFixed(2)}';
  bool get hasBalance => balance > 0;
  bool get isLowBalance => balance < 100; // Less than 100 LYD

  @override
  String toString() {
    return 'Wallet(uuid: $uuid, balance: $balanceDisplay, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Wallet &&
        other.uuid == uuid &&
        other.userUuid == userUuid &&
        other.balance == balance &&
        other.currency == currency &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        userUuid.hashCode ^
        balance.hashCode ^
        currency.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
