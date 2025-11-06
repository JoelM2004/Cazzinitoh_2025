import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/leaderboard/ImageWithFallback.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/leaderboard/PodiumPosition.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/leaderboard/RankingList.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static final List<UserWithScore> mockPlayers = [
    UserWithScore(
      user: UserModel(
        id: "1",
        name: "Escudero",
        nameTag: "ESCUDETOOO",
        fechaNacimiento: DateTime(1995, 5, 15),
        email: "escudero@example.com",
        profilePictureUrl:
            "https://a.espncdn.com/combiner/i?img=/i/headshots/rpm/players/full/348.png&w=350&h=254",
        idAchievements: [1, 5, 9],
      ),
      score: 15420,
    ),
    UserWithScore(
      user: UserModel(
        id: "2",
        name: "Gaspar",
        nameTag: "GASPACHO",
        fechaNacimiento: DateTime(1998, 3, 22),
        email: "gaspar@example.com",
        profilePictureUrl:
            "https://images.unsplash.com/photo-1675310854573-c5c8e4089426?w=400",
        idAchievements: [2, 7],
      ),
      score: 14850,
    ),
    UserWithScore(
      user: UserModel(
        id: "3",
        name: "Carlos",
        nameTag: "LA CABRA",
        fechaNacimiento: DateTime(1996, 8, 10),
        email: "carlos@example.com",
        profilePictureUrl:
            "https://images.unsplash.com/photo-1675310854573-c5c8e4089426?w=400",
        idAchievements: [3, 4, 8],
      ),
      score: 13290,
    ),
    UserWithScore(
      user: UserModel(
        id: "4",
        name: "Buffalo",
        nameTag: "EL BUFFALO KING",
        fechaNacimiento: DateTime(1997, 11, 5),
        email: "buffalo@example.com",
        profilePictureUrl:
            "https://soymotor.com/sites/default/files/2025-03/cleclerc_2025.png",
        idAchievements: [1, 2, 3, 6],
      ),
      score: 12100,
      isCurrentUser: true,
    ),
    UserWithScore(
      user: UserModel(
        id: "5",
        name: "Locuras",
        nameTag: "LOCURAS2004 PAGA",
        fechaNacimiento: DateTime(2004, 1, 20),
        email: "locuras@example.com",
        profilePictureUrl:
            "https://images.unsplash.com/photo-1622349851524-890cc3641b87?w=400",
        idAchievements: [5],
      ),
      score: 11800,
    ),
    UserWithScore(
      user: UserModel(
        id: "6",
        name: "Internautica",
        nameTag: "LA LOCURA INTERNAUTICA",
        fechaNacimiento: DateTime(1999, 6, 30),
        email: "internautica@example.com",
        profilePictureUrl:
            "https://images.unsplash.com/photo-1675310854573-c5c8e4089426?w=400",
        idAchievements: [7, 9],
      ),
      score: 10950,
    ),
  ];

  static const String trophyImage =
      "https://images.unsplash.com/photo-1754300681803-61eadeb79d10?w=400";

  @override
  Widget build(BuildContext context) {
    final currentUser = mockPlayers.firstWhere(
      (player) => player.isCurrentUser,
      orElse: () => mockPlayers.first,
    );
    final currentUserRank = mockPlayers.indexOf(currentUser) + 1;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F172A), // slate-900
                Color(0xFF581C87), // purple-900
                Color(0xFF0F172A), // slate-900
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 448),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header con premio
                        _buildHeader(),
                        const SizedBox(height: 32),

                        // Puntuación del usuario actual
                        _buildCurrentUserCard(currentUser, currentUserRank),
                        const SizedBox(height: 24),

                        // Podio
                        _buildPodium(),
                        const SizedBox(height: 32),

                        // Ranking completo
                        _buildRankingSection(),
                        const SizedBox(height: 32),

                        // Botones de acción
                        _buildActionButtons(),
                        const SizedBox(height: 32),

                        // Footer
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        ImageWithFallback(
          imageUrl: trophyImage,
          width: 80,
          height: 80,
          borderRadius: 40,
          borderWidth: 4,
          borderColor: const Color(0xFFFBBF24), // yellow-400
        ),
        const SizedBox(height: 16),
        const Text(
          'Clasificación Final',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '¡Felicidades por completar el desafío!',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFE9D5FF), // purple-200
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentUserCard(UserWithScore currentUserWithScore, int rank) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0x807F1D1D), // red-900/50
            Color(0x807E22CE), // purple-900/50
          ],
        ),
        border: Border.all(color: const Color(0xFFEF4444), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ImageWithFallback(
                imageUrl: currentUserWithScore.avatar,
                width: 48,
                height: 48,
                borderRadius: 24,
                borderWidth: 2,
                borderColor: const Color(0xFFF87171), // red-400
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tu Resultado',
                    style: TextStyle(
                      color: Color(0xFFFCA5A5), // red-300
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Posición #$rank',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currentUserWithScore.score.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFCA5A5), // red-300
                ),
              ),
              const Text(
                'puntos',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFFECDD3), // red-200
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodium() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.emoji_events, color: Color(0xFFE9D5FF), size: 24),
            SizedBox(width: 8),
            Text(
              'Podio de Campeones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE9D5FF), // purple-200
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 2nd Place
            PodiumPosition(
              rank: 2,
              userWithScore: mockPlayers[1],
              height: 80,
              player: null,
            ),
            const SizedBox(width: 16),
            // 1st Place
            PodiumPosition(
              rank: 1,
              userWithScore: mockPlayers[0],
              height: 112,
              player: null,
            ),
            const SizedBox(width: 16),
            // 3rd Place
            PodiumPosition(
              rank: 3,
              userWithScore: mockPlayers[2],
              height: 64,
              player: null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRankingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Clasificación Completa',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE9D5FF), // purple-200
          ),
        ),
        const SizedBox(height: 16),
        RankingList(players: mockPlayers.sublist(3), startRank: 4),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Handle restart
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9333EA), // purple-600
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Color(0xFFA855F7), // purple-500
                  width: 2,
                ),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 20),
                SizedBox(width: 12),
                Text(
                  'Jugar de Nuevo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              // Handle go home
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0x801F2937), // gray-800/50
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Color(0xFF4B5563), // gray-600
                  width: 2,
                ),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, size: 20),
                SizedBox(width: 12),
                Text(
                  'Volver al Inicio',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF374151), width: 1), // gray-700
        ),
      ),
      child: const Text(
        'Memory Trip • Desafío completado',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF9CA3AF), // gray-400
        ),
      ),
    );
  }
}
