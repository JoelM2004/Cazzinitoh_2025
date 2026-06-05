import 'package:cazzinitoh_2025/src/features/users/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.nameTag,
    required super.fechaNacimiento,
    required super.email,
    required super.profilePictureUrl,
    required super.idAchievements,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {

  DateTime parseFecha(dynamic raw) {
    if (raw == null) return DateTime.now();
    if (raw is DateTime) return raw;
    if (raw is String) return DateTime.tryParse(raw) ?? DateTime.now();
    return DateTime.now();
  }

  List<int> parseIdAchievements(dynamic raw) {
    if (raw == null) return <int>[];
    if (raw is List) {
      return raw
          .map<int?>((e) {
            if (e == null) return null;
            if (e is int) return e;
            if (e is double) return e.toInt();
            if (e is String) return int.tryParse(e);
            return null;
          })
          .where((x) => x != null)
          .cast<int>()
          .toList();
    }
    if (raw is String) {
      final cleaned = raw.replaceAll(RegExp(r'[\[\]\s]'), '');
      if (cleaned.isEmpty) return <int>[];
      return cleaned
          .split(',')
          .map((s) => int.tryParse(s))
          .where((x) => x != null)
          .cast<int>()
          .toList();
    }
    return <int>[];
  }

  return UserModel(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    nameTag: json['nameTag']?.toString() ?? '',
    fechaNacimiento: parseFecha(json['fechaNacimiento']), // ← fix
    email: json['email']?.toString() ?? '',
    profilePictureUrl: json['profilePictureUrl']?.toString() ?? '',
    idAchievements: parseIdAchievements(json['idAchievements']),
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameTag': nameTag,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'idAchievements': idAchievements,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      nameTag: user.nameTag,
      fechaNacimiento: user.fechaNacimiento,
      email: user.email,
      profilePictureUrl: user.profilePictureUrl,
      idAchievements: user.idAchievements,
    );
  }
}

// Helper class para agregar puntos al usuario en el leaderboard
class UserWithScore {
  final UserModel user;
  final int score;
  final bool isCurrentUser;

  const UserWithScore({
    required this.user,
    required this.score,
    this.isCurrentUser = false,
  });

  String get displayName => user.nameTag.isNotEmpty ? user.nameTag : user.name;
  String get avatar => user.profilePictureUrl;
  String get id => user.id;
  int get edad => user.age;
  String get email => user.email;
  DateTime get fechaNacimiento => user.fechaNacimiento;
  List<int> get idAchievements => user.idAchievements;
}
