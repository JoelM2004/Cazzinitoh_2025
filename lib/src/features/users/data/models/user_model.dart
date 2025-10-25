import 'package:cazzinitoh_2025/src/features/users/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      if (raw == null) return DateTime.fromMillisecondsSinceEpoch(0);
      if (raw is Timestamp) return raw.toDate();
      if (raw is DateTime) return raw;
      if (raw is String) {
        try {
          return DateTime.parse(raw);
        } catch (_) {
          final n = int.tryParse(raw);
          if (n != null) {
            final maybeMs = n > 100000000000 ? n : n * 1000;
            return DateTime.fromMillisecondsSinceEpoch(maybeMs);
          }
        }
      }
      if (raw is int) {
        final maybeMs = raw > 100000000000 ? raw : raw * 1000;
        return DateTime.fromMillisecondsSinceEpoch(maybeMs);
      }
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    // Parse idAchievements de forma segura
    List<int> parseIdAchievements(dynamic raw) {
      if (raw == null) return <int>[];
      if (raw is List) {
        return raw
            .map<int?>((e) {
              if (e == null) return null;
              if (e is int) return e;
              if (e is double) return e.toInt();
              if (e is String) return int.tryParse(e);
              // Si viene como DocumentReference u otro tipo, ignorar
              return null;
            })
            .where((x) => x != null)
            .cast<int>()
            .toList();
      }
      // si vino como String con formato "[1,9]"
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
      fechaNacimiento: parseFecha(json['fechaNacimiento']),
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
