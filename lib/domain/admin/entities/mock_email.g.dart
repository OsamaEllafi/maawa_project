// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MockEmail _$MockEmailFromJson(Map<String, dynamic> json) => MockEmail(
  uuid: json['uuid'] as String,
  type: json['type'] as String,
  recipientEmail: json['recipientEmail'] as String,
  recipientName: json['recipientName'] as String,
  subject: json['subject'] as String,
  htmlContent: json['htmlContent'] as String,
  textContent: json['textContent'] as String,
  data: json['data'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  sentAt: json['sentAt'] == null
      ? null
      : DateTime.parse(json['sentAt'] as String),
  isRead: json['isRead'] as bool,
);

Map<String, dynamic> _$MockEmailToJson(MockEmail instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'type': instance.type,
  'recipientEmail': instance.recipientEmail,
  'recipientName': instance.recipientName,
  'subject': instance.subject,
  'htmlContent': instance.htmlContent,
  'textContent': instance.textContent,
  'data': instance.data,
  'createdAt': instance.createdAt.toIso8601String(),
  'sentAt': instance.sentAt?.toIso8601String(),
  'isRead': instance.isRead,
};
