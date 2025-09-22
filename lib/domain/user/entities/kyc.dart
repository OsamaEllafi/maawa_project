import 'package:json_annotation/json_annotation.dart';

part 'kyc.g.dart';

enum KYCStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('verified')
  verified,
  @JsonValue('rejected')
  rejected,
}

@JsonSerializable()
class KYC {
  final String uuid;
  final String fullName;
  final String idNumber;
  final String iban;
  final KYCStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? verifiedAt;
  final DateTime? rejectedAt;

  const KYC({
    required this.uuid,
    required this.fullName,
    required this.idNumber,
    required this.iban,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.verifiedAt,
    this.rejectedAt,
  });

  factory KYC.fromJson(Map<String, dynamic> json) => _$KYCFromJson(json);
  Map<String, dynamic> toJson() => _$KYCToJson(this);

  KYC copyWith({
    String? uuid,
    String? fullName,
    String? idNumber,
    String? iban,
    KYCStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? verifiedAt,
    DateTime? rejectedAt,
  }) {
    return KYC(
      uuid: uuid ?? this.uuid,
      fullName: fullName ?? this.fullName,
      idNumber: idNumber ?? this.idNumber,
      iban: iban ?? this.iban,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
    );
  }

  bool get isPending => status == KYCStatus.pending;
  bool get isVerified => status == KYCStatus.verified;
  bool get isRejected => status == KYCStatus.rejected;
  bool get hasNotes => notes != null && notes!.isNotEmpty;

  @override
  String toString() {
    return 'KYC(uuid: $uuid, fullName: $fullName, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KYC &&
        other.uuid == uuid &&
        other.fullName == fullName &&
        other.idNumber == idNumber &&
        other.iban == iban &&
        other.status == status &&
        other.notes == notes &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.verifiedAt == verifiedAt &&
        other.rejectedAt == rejectedAt;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        fullName.hashCode ^
        idNumber.hashCode ^
        iban.hashCode ^
        status.hashCode ^
        notes.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        verifiedAt.hashCode ^
        rejectedAt.hashCode;
  }
}
