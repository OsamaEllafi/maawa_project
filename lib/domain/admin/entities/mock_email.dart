import 'package:json_annotation/json_annotation.dart';

part 'mock_email.g.dart';

enum MockEmailType {
  @JsonValue('welcome')
  welcome,
  @JsonValue('password_reset')
  passwordReset,
  @JsonValue('email_verification')
  emailVerification,
  @JsonValue('booking_confirmation')
  bookingConfirmation,
  @JsonValue('booking_cancellation')
  bookingCancellation,
  @JsonValue('property_approved')
  propertyApproved,
  @JsonValue('property_rejected')
  propertyRejected,
  @JsonValue('kyc_verified')
  kycVerified,
  @JsonValue('kyc_rejected')
  kycRejected,
  @JsonValue('payment_success')
  paymentSuccess,
  @JsonValue('payment_failed')
  paymentFailed,
}

@JsonSerializable()
class MockEmail {
  final String uuid;
  final String type;
  final String recipientEmail;
  final String recipientName;
  final String subject;
  final String htmlContent;
  final String textContent;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final DateTime? sentAt;
  final bool isRead;

  const MockEmail({
    required this.uuid,
    required this.type,
    required this.recipientEmail,
    required this.recipientName,
    required this.subject,
    required this.htmlContent,
    required this.textContent,
    this.data,
    required this.createdAt,
    this.sentAt,
    required this.isRead,
  });

  factory MockEmail.fromJson(Map<String, dynamic> json) => _$MockEmailFromJson(json);
  Map<String, dynamic> toJson() => _$MockEmailToJson(this);

  MockEmail copyWith({
    String? uuid,
    String? type,
    String? recipientEmail,
    String? recipientName,
    String? subject,
    String? htmlContent,
    String? textContent,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? sentAt,
    bool? isRead,
  }) {
    return MockEmail(
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      recipientEmail: recipientEmail ?? this.recipientEmail,
      recipientName: recipientName ?? this.recipientName,
      subject: subject ?? this.subject,
      htmlContent: htmlContent ?? this.htmlContent,
      textContent: textContent ?? this.textContent,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
    );
  }

  // Type helpers
  MockEmailType? get emailType {
    try {
      return MockEmailType.values.firstWhere((e) => e.toString().split('.').last == type);
    } catch (e) {
      return null;
    }
  }

  bool get isWelcomeEmail => type == 'welcome';
  bool get isPasswordReset => type == 'password_reset';
  bool get isEmailVerification => type == 'email_verification';
  bool get isBookingConfirmation => type == 'booking_confirmation';
  bool get isBookingCancellation => type == 'booking_cancellation';
  bool get isPropertyApproved => type == 'property_approved';
  bool get isPropertyRejected => type == 'property_rejected';
  bool get isKycVerified => type == 'kyc_verified';
  bool get isKycRejected => type == 'kyc_rejected';
  bool get isPaymentSuccess => type == 'payment_success';
  bool get isPaymentFailed => type == 'payment_failed';

  // Status helpers
  bool get isSent => sentAt != null;
  bool get isUnread => !isRead;

  // Content helpers
  bool get hasHtmlContent => htmlContent.isNotEmpty;
  bool get hasTextContent => textContent.isNotEmpty;
  String get previewText {
    final text = textContent.isNotEmpty ? textContent : htmlContent;
    if (text.length <= 150) return text;
    return '${text.substring(0, 150)}...';
  }

  // Data helpers
  bool get hasData => data != null && data!.isNotEmpty;

  // Date helpers
  bool get isRecent => DateTime.now().difference(createdAt).inDays < 1;
  bool get isToday => DateTime.now().difference(createdAt).inDays == 0;
  bool get isYesterday => DateTime.now().difference(createdAt).inDays == 1;

  @override
  String toString() {
    return 'MockEmail(uuid: $uuid, type: $type, recipient: $recipientEmail, subject: $subject)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MockEmail &&
        other.uuid == uuid &&
        other.type == type &&
        other.recipientEmail == recipientEmail &&
        other.recipientName == recipientName &&
        other.subject == subject &&
        other.htmlContent == htmlContent &&
        other.textContent == textContent &&
        other.data == data &&
        other.createdAt == createdAt &&
        other.sentAt == sentAt &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        type.hashCode ^
        recipientEmail.hashCode ^
        recipientName.hashCode ^
        subject.hashCode ^
        htmlContent.hashCode ^
        textContent.hashCode ^
        data.hashCode ^
        createdAt.hashCode ^
        sentAt.hashCode ^
        isRead.hashCode;
  }
}
