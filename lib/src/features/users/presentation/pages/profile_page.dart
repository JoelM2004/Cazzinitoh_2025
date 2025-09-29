import 'package:cazzinitoh_2025/src/core/session/session.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/profile/profile.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _user = Session.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileForm(
        initialData: _user,
        onSave: (userData) {
          setState(() {
            _user = userData;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil guardado con éxito'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context); // volver a la pantalla anterior si querés
        },
        onCancel: () {
          Navigator.pop(context); // cerrar formulario
        },
      ),
    );
  }
}
