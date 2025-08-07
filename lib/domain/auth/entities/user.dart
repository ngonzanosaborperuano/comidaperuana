import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:recetasperuanas/domain/auth/value_objects/email.dart';
import 'package:recetasperuanas/domain/auth/value_objects/password.dart';
import 'package:recetasperuanas/domain/auth/value_objects/user_id.dart';
import 'package:recetasperuanas/domain/core/value_objects.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    this.password,
    this.name,
    this.photoUrl,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  @JsonKey(fromJson: _userIdFromJson, toJson: _userIdToJson)
  final UserId id;

  @JsonKey(fromJson: _emailFromJson, toJson: _emailToJson)
  final Email email;

  @JsonKey(fromJson: _passwordFromJson, toJson: _passwordToJson)
  final Password? password;
  final String? name;
  final String? photoUrl;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Factory constructor with validation
  static Result<User, ValidationException> create({
    String? id,
    required String email,
    String? password,
    String? name,
    String? photoUrl,
    bool isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    // Validate ID if provided
    UserId? userIdVO;
    if (id != null) {
      final userIdResult = UserId.create(id);
      if (userIdResult.isFailure) {
        return Failure(userIdResult.failureValue!);
      }
      userIdVO = userIdResult.successValue;
    } else {
      // Use 0 as default ID for registration
      userIdVO = const UserId('0');
    }

    // Validate email
    final emailResult = Email.create(email);
    if (emailResult.isFailure) {
      return Failure(emailResult.failureValue!);
    }

    // Validate password if provided
    Password? passwordVO;
    if (password != null) {
      final passwordResult = Password.create(password);
      if (passwordResult.isFailure) {
        return Failure(passwordResult.failureValue!);
      }
      passwordVO = passwordResult.successValue;
    }

    // Validate name if provided
    if (name != null && name.trim().isEmpty) {
      return const Failure(ValidationException('El nombre no puede estar vacío'));
    }

    return Success(
      User(
        id: userIdVO!,
        email: emailResult.successValue!,
        password: passwordVO,
        name: name?.trim(),
        photoUrl: photoUrl,
        isActive: isActive,
        createdAt: createdAt ?? DateTime.now(),
        updatedAt: updatedAt ?? DateTime.now(),
      ),
    );
  }

  @override
  List<Object?> get props => [id, email, name, photoUrl, isActive, createdAt, updatedAt];

  @override
  String toString() => 'User(id: ${id.value}, email: ${email.value}, name: $name)';

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Convert User to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // JSON conversion helpers
  static UserId _userIdFromJson(String value) => UserId(value);
  static String _userIdToJson(UserId userId) => userId.value;

  static Email _emailFromJson(String value) => Email(value);
  static String _emailToJson(Email email) => email.value;

  static Password? _passwordFromJson(String? value) => value != null ? Password(value) : null;
  static String? _passwordToJson(Password? password) => password?.value;
}
