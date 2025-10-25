import 'package:flutter/material.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/update_user/update_user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cazzinitoh_2025/src/features/achievements/presentation/widgets/achievements/achievementListView.dart';
import 'package:cazzinitoh_2025/src/core/achievements/achievements.dart';
import 'package:cazzinitoh_2025/src/features/achievements/presentation/widgets/achievements/achievementsListViewByIds.dart';

class ProfileForm extends StatefulWidget {
  final UserModel? initialData;
  final Function(UserModel) onSave;
  final VoidCallback onCancel;

  const ProfileForm({
    Key? key,
    this.initialData,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  DateTime? _selectedFechaNacimiento;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _nameTagController;
  late TextEditingController _fechaNacimientoController;
  late TextEditingController _gamerTagController;
  late TextEditingController _idAchievementsController;

  String _profilePictureUrl = '';
  bool _isUploading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedFechaNacimiento = widget.initialData?.fechaNacimiento;
    _fechaNacimientoController = TextEditingController(
      text: _selectedFechaNacimiento != null
          ? _selectedFechaNacimiento!.toIso8601String().split('T').first
          : '',
    );

    _nameController = TextEditingController(
      text: widget.initialData?.name ?? '',
    );
    _emailController = TextEditingController(
      text: widget.initialData?.email ?? '',
    );
    _nameTagController = TextEditingController(
      text: widget.initialData?.nameTag ?? '',
    );
    _gamerTagController = TextEditingController(
      text: widget.initialData?.nameTag ?? '',
    );
    _profilePictureUrl =
        widget.initialData?.profilePictureUrl ??
        'https://images.unsplash.com/photo-1655780004656-514350b9c8aa?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxnYW1pbmclMjBhdmF0YXIlMjBwcm9maWxlJTIwZ290aGljfGVufDF8fHx8MTc1ODIwNDczNHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nameTagController.dispose();
    _fechaNacimientoController.dispose();
    _gamerTagController.dispose();
    super.dispose();
  }

  void _handleAvatarUpload() {
    setState(() {
      _isUploading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final nameTag = _gamerTagController.text;
      // Usar la fecha seleccionada (DateTime). Si no hay fecha, usar ahora.
      final fechaNacimiento = _selectedFechaNacimiento ?? DateTime.now();

      // Disparar el evento de Update con DateTime
      context.read<UpdateUserBloc>().add(
        UpdateUser(
          name: name,
          nameTag: nameTag,
          fechaNacimiento: fechaNacimiento,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Set<int> userAchievementIds =
        (widget.initialData?.idAchievements ?? <int>[]).toSet();
    return Scaffold(
      body: BlocListener<UpdateUserBloc, UpdateUserState>(
        listener: (context, state) {
          if (state is UpdateUserSuccess) {
            // Crear el usuario actualizado con los datos del formulario
            final updatedUser = UserModel(
              id:
                  widget.initialData?.id ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              name: _nameController.text,
              nameTag: _nameTagController.text,
              fechaNacimiento: _selectedFechaNacimiento!,
              email: widget.initialData?.email ?? '',
              profilePictureUrl: _profilePictureUrl,
              idAchievements: widget.initialData?.idAchievements ?? [],
            );

            // Llamar al callback onSave con el usuario actualizado
            widget.onSave(updatedUser);

            // Mostrar SnackBar de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perfil actualizado correctamente',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tus cambios han sido guardados exitosamente.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFF374151),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFF7C3AED), width: 1),
                ),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 3),
              ),
            );

            // Resetear el estado del bloc
            context.read<UpdateUserBloc>().add(UpdateUserReset());
          } else if (state is UpdateUserFailure) {
            // Mostrar error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Error al actualizar perfil',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Se produjo un error:",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFF7F1D1D),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFFEF4444), width: 1),
                ),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 4),
              ),
            );

            // Resetear el estado del bloc
            context.read<UpdateUserBloc>().add(UpdateUserReset());
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF111827), // gray-900
                Color(0xFF581C87), // purple-900
                Color(0xFF4C1D95), // violet-900
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 448),
                      child: Column(
                        children: [
                          const SizedBox(height: 32),

                          // Botón volver
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),

                          // Header con avatar
                          _buildAvatarSection(),
                          const SizedBox(height: 24),
                          const Text(
                            'Editar Perfil',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Personaliza tu experiencia de juego',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFD8B4FE),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Formulario
                          _buildFormCard(userAchievementIds),

                          // Información adicional
                          const SizedBox(height: 24),
                          Text(
                            'Los cambios se aplicarán inmediatamente',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFFA855F7).withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),

                // Loading overlay
                BlocBuilder<UpdateUserBloc, UpdateUserState>(
                  builder: (context, state) {
                    if (state is UpdateUserLoading) {
                      return Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF8B5CF6),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Actualizando perfil...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF8B5CF6), width: 4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withOpacity(0.25),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipOval(
            child: _profilePictureUrl.isNotEmpty
                ? Image.network(
                    _profilePictureUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF6B21A8),
                        child: const Icon(
                          Icons.person,
                          size: 48,
                          color: Color(0xFFD8B4FE),
                        ),
                      );
                    },
                  )
                : Container(
                    color: const Color(0xFF6B21A8),
                    child: const Icon(
                      Icons.person,
                      size: 48,
                      color: Color(0xFFD8B4FE),
                    ),
                  ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Transform.translate(
              offset: const Offset(0, 12),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isUploading
                      ? const Color(0xFF6D28D9)
                      : const Color(0xFF7C3AED),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isUploading ? null : _handleAvatarUpload,
                    customBorder: const CircleBorder(),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFechaNacimiento() async {
    final now = DateTime.now();
    final initial =
        _selectedFechaNacimiento ?? DateTime(now.year - 18, now.month, now.day);
    final firstDate = DateTime(1900);
    final lastDate = now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Seleccioná tu fecha de nacimiento',
      fieldLabelText: 'Fecha de nacimiento',
    );

    if (picked != null) {
      setState(() {
        _selectedFechaNacimiento = picked;

        final y = picked.year.toString().padLeft(4, '0');
        final m = picked.month.toString().padLeft(2, '0');
        final d = picked.day.toString().padLeft(2, '0');
        _fechaNacimientoController.text = '$y-$m-$d';
      });
    }
  }

  Widget _buildFormCard(Set<int> userAchievementIds) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 24, spreadRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: const [
                Icon(Icons.shield, size: 20, color: Color(0xFFD8B4FE)),
                SizedBox(width: 8),
                Text(
                  'Información Personal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD8B4FE),
                  ),
                ),
              ],
            ),
          ),

          // Card Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  _buildInputField(
                    label: 'Nombre de Usuario',
                    icon: Icons.person,
                    controller: _nameController,
                    placeholder: 'Ingresa tu nombre',
                    required: true,
                  ),
                  const SizedBox(height: 24),

                  // Gamer Tag
                  _buildInputField(
                    label: 'Gamer Tag',
                    icon: Icons.emoji_events,
                    controller: _gamerTagController,
                    placeholder: 'Tu identificador único',
                  ),
                  const SizedBox(height: 24),

                  // Email
                  _buildInputField(
                    label: 'Correo Electrónico (No modificable)',
                    controller: _emailController,
                    placeholder: 'tu@email.com',
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
                  ),
                  const SizedBox(height: 24),

                  // Edad
                  GestureDetector(
                    onTap: _pickFechaNacimiento,
                    child: AbsorbPointer(
                      child: _buildInputField(
                        label: 'Fecha de nacimiento',
                        icon: Icons.star,
                        controller: _fechaNacimientoController,
                        placeholder: 'aaaa-mm-dd',
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const SizedBox(height: 24),
                  Text(
                    'Logros',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 320,
                    child: AchievementsListViewByIds(
                      userAchievementIds: userAchievementIds,
                      achievementSrc: AchievementSrc(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botones de acción
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: const Color(
                              0xFF8B5CF6,
                            ).withOpacity(0.25),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Guardar Cambios',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: widget.onCancel,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD1D5DB),
                            side: const BorderSide(color: Color(0xFF4B5563)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    IconData? icon,
    required TextEditingController controller,
    required String placeholder,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: const Color(0xFFE9D5FF)),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFE9D5FF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          style: const TextStyle(color: Colors.white),
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: const Color(0xFFD8B4FE).withOpacity(0.5),
            ),
            filled: true,
            fillColor: const Color(0xFF374151).withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFF8B5CF6).withOpacity(0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFF8B5CF6).withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFA855F7), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFF4B5563).withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
