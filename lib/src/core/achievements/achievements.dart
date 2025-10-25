import 'package:cazzinitoh_2025/src/features/achievements/domain/entities/achievement.dart';

class AchievementSrc {
  static List<Achievement> achievements = [
    Achievement(
      id: 1,
      name: 'Principiante I',
      description:
          'Insignia para aquellos guerreros que están iniciando con su leyenda.',
      pictureUrl: "assets/images/achievements/Top9.png",
      requisito: 'Completa un reto para conseguirlo.',
    ),
    Achievement(
      id: 2,
      name: 'Principiante II',
      description:
          'Insignia para aquellos guerreros que están iniciando con su leyenda.',
      pictureUrl: "assets/images/achievements/Top8.png",
      requisito: 'Completa cinco retos para conseguirlo.',
    ),
    Achievement(
      id: 3,
      name: 'Guerrero I',
      description:
          'Insignia para aquellos guerreros que están iniciando con su leyenda.',
      pictureUrl: "assets/images/achievements/Top7.png",
      requisito: 'Completa dos retos en menos de 12 horas para conseguirlo.',
    ),
    Achievement(
      id: 4,
      name: 'Guerrero II',
      description:
          'Insignia para aquellos guerreros que están iniciando con su leyenda.',
      pictureUrl: "assets/images/achievements/Top6.png",
      requisito: 'Completa diez retos para conseguirlo.',
    ),
    Achievement(
      id: 5,
      name: 'Guerrero III',
      description:
          'Insignia para aquellos guerreros que están iniciando con su leyenda.',
      pictureUrl: "assets/images/achievements/Top5.png",
      requisito: 'Completa tres retos en menos de 12 horas para conseguirlo.',
    ),
    Achievement(
      id: 6,
      name: 'Maestro I',
      description:
          'Insignia para aquellos guerreros que están iniciando con su leyenda.',
      pictureUrl: "assets/images/achievements/Top4.png",
      requisito: 'Completa veinte retos para conseguirlo.',
    ),
    Achievement(
      id: 7,
      name: 'Maestro II',
      description:
          'Insignia para aquellos guerreros que están iniciando con su leyenda.',
      pictureUrl: "assets/images/achievements/Top3.png",
      requisito: 'Completa cuarenta retos para conseguirlo.',
    ),
    Achievement(
      id: 8,
      name: 'Maestro III',
      description:
          'Insignia para aquellos guerreros que están iniciando con su leyenda.',
      pictureUrl: "assets/images/achievements/Top2.png",
      requisito: 'Completa siete retos en menos de 18 horas para conseguirlo.',
    ),
    Achievement(
      id: 9,
      name: 'Gran Maestro',
      description:
          'La fakin bestia de todas las bestias. El guerrero definitivo.',
      pictureUrl: "assets/images/achievements/Top1.png",
      requisito: 'Consigue todos los logros para obtenerlo.',
    ),
  ];

  List<Achievement> achievementsList() {
    return achievements;
  }
}
