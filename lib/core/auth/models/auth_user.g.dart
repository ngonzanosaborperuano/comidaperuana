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
  if (instance.id case final value?) 'id': value,
  if (instance.nombreCompleto case final value?) 'nombre_completo': value,
  'email': instance.email,
  if (instance.contrasena case final value?) 'contrasena': value,
  if (instance.sessionToken case final value?) 'session_token': value,
  if (instance.foto case final value?) 'foto': value,
};
