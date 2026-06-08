// lib/src/core/appwrite/appwrite_client.dart
import 'package:appwrite/appwrite.dart';

class AppwriteConfig {
  static const String endpoint = 'https://sfo.cloud.appwrite.io/v1';
  static const String projectId = '6a22303f002ed1ded124';
  static const String projectName = 'caminando';
  
  // Estos los completás después de crear la DB y colección
  static const String databaseId = '6a2230800001d5bd9209';
  static const String usersCollectionId = 'users';
  static const String leaderboardCollectionId = 'leaderboard';
  static const String statsCollectionId="stats";
  static const String avatarsBucketId = '6a22316200007cbfcc1b';

  static Client get client => Client()
    ..setEndpoint(endpoint)
    ..setProject(projectId);
}