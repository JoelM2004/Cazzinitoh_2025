import 'package:cazzinitoh_2025/src/features/users/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.nameTag,
    required super.age,
    required super.email,
    required super.profilePictureUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameTag: json['nameTag'] as String,
      age: json['age'] as int,
      email: json['email'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameTag': nameTag,
      'age': age,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      nameTag: user.nameTag,
      age: user.age,
      email: user.email,
      profilePictureUrl: user.profilePictureUrl,
    );
  }
}
