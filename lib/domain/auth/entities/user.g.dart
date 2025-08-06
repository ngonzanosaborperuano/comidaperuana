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
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': User._userIdToJson(instance.id),
  'email': User._emailToJson(instance.email),
  if (User._passwordToJson(instance.password) case final value?)
    'password': value,
  if (instance.name case final value?) 'name': value,
  if (instance.photoUrl case final value?) 'photo_url': value,
  'is_active': instance.isActive,
  if (instance.createdAt?.toIso8601String() case final value?)
    'created_at': value,
  if (instance.updatedAt?.toIso8601String() case final value?)
    'updated_at': value,
};
