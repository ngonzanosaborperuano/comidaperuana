import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_models.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  final int id;
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String avatar;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static const UserModel empty = UserModel(
    id: 0,
    email: '',
    firstName: '',
    lastName: '',
    avatar: '',
  );

  @override
  List<Object?> get props => [id, email, firstName, lastName, avatar];
}
