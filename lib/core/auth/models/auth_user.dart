import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_user.g.dart';

@JsonSerializable()
class AuthUser extends Equatable {
  const AuthUser({
    this.id,
    required this.email,
    this.nombreCompleto,
    this.contrasena,
    this.sessionToken,
    this.foto,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);

  final int? id;
  final String? nombreCompleto;
  final String email;
  final String? contrasena;
  final String? sessionToken;
  final String? foto;

  Map<String, dynamic> toJson() => _$AuthUserToJson(this);

  AuthUser toModel() {
    return AuthUser(
      id: id,
      email: email,
      contrasena: contrasena,
      nombreCompleto: nombreCompleto,
      sessionToken: sessionToken,
      foto: foto,
    );
  }

  static AuthUser empty() {
    return const AuthUser(
      id: 0,
      email: '',
      foto: '',
      contrasena: '',
      sessionToken: '',
      nombreCompleto: '',
    );
  }

  @override
  List<Object?> get props => [id, email, contrasena, sessionToken, nombreCompleto, foto];
}
