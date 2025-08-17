// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => AuthUser(
  id: (json['id'] as num?)?.toInt(),
  email: json['email'] as String,
  nombreCompleto: json['nombre_completo'] as String?,
  contrasena: json['contrasena'] as String?,
  sessionToken: json['session_token'] as String?,
  foto: json['foto'] as String?,
);

Map<String, dynamic> _$AuthUserToJson(AuthUser instance) => <String, dynamic>{
  'id': ?instance.id,
  'nombre_completo': ?instance.nombreCompleto,
  'email': instance.email,
  'contrasena': ?instance.contrasena,
  'session_token': ?instance.sessionToken,
  'foto': ?instance.foto,
};
