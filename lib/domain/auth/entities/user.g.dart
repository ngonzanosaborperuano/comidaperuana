// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: User._userIdFromJson(json['id'] as String),
  email: User._emailFromJson(json['email'] as String),
  password: User._passwordFromJson(json['password'] as String?),
  name: json['name'] as String?,
  photoUrl: json['photo_url'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': User._userIdToJson(instance.id),
  'email': User._emailToJson(instance.email),
  'password': ?User._passwordToJson(instance.password),
  'name': ?instance.name,
  'photo_url': ?instance.photoUrl,
  'is_active': instance.isActive,
  'created_at': ?instance.createdAt?.toIso8601String(),
  'updated_at': ?instance.updatedAt?.toIso8601String(),
};
