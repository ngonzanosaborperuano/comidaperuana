import 'package:equatable/equatable.dart';
import 'package:goncook/common/shared.dart' show AppResultService;
import 'package:goncook/core/generics/value_objects/email.dart';
import 'package:goncook/core/generics/value_objects/password.dart';
import 'package:goncook/core/generics/value_objects/user_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  const UserModel({
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
  static AppResultService<UserModel> create({
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
        return AppResultService.failure(userIdResult.errorMessage!);
      }
      userIdVO = userIdResult.valueOrNull;
    } else {
      // Use 0 as default ID for registration
      userIdVO = const UserId('0');
    }

    // Validate email
    final emailResult = Email.create(email);
    if (emailResult.isFailure) {
      return AppResultService.failure(emailResult.errorMessage!);
    }

    // Validate password if provided
    Password? passwordVO;
    if (password != null) {
      final passwordResult = Password.create(password);
      if (passwordResult.isFailure) {
        return AppResultService.failure(passwordResult.errorMessage!);
      }
      passwordVO = passwordResult.valueOrNull;
    }

    // Validate name if provided
    if (name != null && name.trim().isEmpty) {
      return const AppResultService.failure('El nombre no puede estar vacío');
    }

    return AppResultService.success(
      UserModel(
        id: userIdVO!,
        email: emailResult.valueOrNull!,
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
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  /// Convert User to JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // JSON conversion helpers
  static UserId _userIdFromJson(String value) => UserId(value);
  static String _userIdToJson(UserId userId) => userId.value;

  static Email _emailFromJson(String value) => Email(value);
  static String _emailToJson(Email email) => email.value;

  static Password? _passwordFromJson(String? value) => value != null ? Password(value) : null;
  static String? _passwordToJson(Password? password) => password?.value;
}
