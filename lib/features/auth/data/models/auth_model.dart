import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel extends Equatable {
  const AuthModel({
    this.id,
    required this.email,
    this.nombreCompleto,
    this.contrasena,
    this.sessionToken,
    this.foto,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);

  final int? id;
  final String? nombreCompleto;
  final String email;
  final String? contrasena;
  final String? sessionToken;
  final String? foto;

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);

  AuthModel toModel() {
    return AuthModel(
      id: id,
      email: email,
      contrasena: contrasena,
      nombreCompleto: nombreCompleto,
      sessionToken: sessionToken,
      foto: foto,
    );
  }

  static AuthModel empty() {
    return const AuthModel(
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
