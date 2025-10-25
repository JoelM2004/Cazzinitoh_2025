class User {
  final String id;
  final String name;
  final String nameTag;
  final DateTime fechaNacimiento;
  final String email;
  final String profilePictureUrl;
  final List<int> idAchievements;

  User({
    required this.id,
    required this.name,
    required this.nameTag,
    required this.fechaNacimiento,
    required this.email,
    required this.profilePictureUrl,
    required this.idAchievements,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - fechaNacimiento.year;

    final cumpleMes = fechaNacimiento.month;
    final cumpleDia = fechaNacimiento.day;

    final ultimoDiaDelMesDelAnio = DateTime(now.year, cumpleMes + 1, 0).day;
    final diaEsteAnio = cumpleDia <= ultimoDiaDelMesDelAnio
        ? cumpleDia
        : ultimoDiaDelMesDelAnio;

    final cumpleEsteAnio = DateTime(now.year, cumpleMes, diaEsteAnio);

    if (now.isBefore(cumpleEsteAnio)) {
      age -= 1;
    }
    return age;
  }

  List<int> getIdAchievements() {
    return idAchievements;
  }
}
