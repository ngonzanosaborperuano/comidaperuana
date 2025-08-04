import 'package:equatable/equatable.dart';
import 'package:recetasperuanas/domain/auth/value_objects/email.dart';
import 'package:recetasperuanas/domain/auth/value_objects/password.dart';
import 'package:recetasperuanas/domain/auth/value_objects/user_id.dart';
import 'package:recetasperuanas/domain/core/value_objects.dart';

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

  final UserId id;
  final Email email;
  final Password? password;
  final String? name;
  final String? photoUrl;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Factory constructor with validation
  static Result<User, ValidationException> create({
    required String id,
    required String email,
    String? password,
    String? name,
    String? photoUrl,
    bool isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    // Validate ID
    final userIdResult = UserId.create(id);
    if (userIdResult.isFailure) {
      return Failure(userIdResult.failureValue!);
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
      return const Failure(
        ValidationException('El nombre no puede estar vacío'),
      );
    }

    return Success(
      User(
        id: userIdResult.successValue!,
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

  /// Create user without password (for existing users)
  static Result<User, ValidationException> createWithoutPassword({
    required String id,
    required String email,
    String? name,
    String? photoUrl,
    bool isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return create(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Update user information
  User copyWith({
    UserId? id,
    Email? email,
    Password? password,
    String? name,
    String? photoUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Deactivate user
  User deactivate() {
    return copyWith(isActive: false);
  }

  /// Activate user
  User activate() {
    return copyWith(isActive: true);
  }

  /// Check if user can login
  bool get canLogin => isActive && email.isValid;

  /// Get display name
  String get displayName => name ?? email.localPart;

  /// Check if user has profile photo
  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    photoUrl,
    isActive,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() =>
      'User(id: ${id.value}, email: ${email.value}, name: $name)';
}
