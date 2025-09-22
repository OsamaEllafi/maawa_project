import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  final String? phone;
  final String? locale;
  final String? timezone;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? bio;
  final Map<String, dynamic>? preferences;

  const Profile({
    this.phone,
    this.locale,
    this.timezone,
    this.dateOfBirth,
    this.gender,
    this.bio,
    this.preferences,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  Profile copyWith({
    String? phone,
    String? locale,
    String? timezone,
    DateTime? dateOfBirth,
    String? gender,
    String? bio,
    Map<String, dynamic>? preferences,
  }) {
    return Profile(
      phone: phone ?? this.phone,
      locale: locale ?? this.locale,
      timezone: timezone ?? this.timezone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      preferences: preferences ?? this.preferences,
    );
  }

  bool get hasPhone => phone != null && phone!.isNotEmpty;
  bool get hasLocale => locale != null && locale!.isNotEmpty;
  bool get hasTimezone => timezone != null && timezone!.isNotEmpty;
  bool get hasDateOfBirth => dateOfBirth != null;
  bool get hasGender => gender != null && gender!.isNotEmpty;
  bool get hasBio => bio != null && bio!.isNotEmpty;

  @override
  String toString() {
    return 'Profile(phone: $phone, locale: $locale, timezone: $timezone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Profile &&
        other.phone == phone &&
        other.locale == locale &&
        other.timezone == timezone &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        other.bio == bio &&
        other.preferences == preferences;
  }

  @override
  int get hashCode {
    return phone.hashCode ^
        locale.hashCode ^
        timezone.hashCode ^
        dateOfBirth.hashCode ^
        gender.hashCode ^
        bio.hashCode ^
        preferences.hashCode;
  }
}
