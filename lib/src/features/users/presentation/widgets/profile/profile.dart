import 'dart:io';
import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:cazzinitoh_2025/src/features/shared/widgets/app_alert.dart';
import 'package:cazzinitoh_2025/src/features/shared/widgets/app_back_nav_bar.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/update_user/update_user_bloc.dart';
import 'package:cazzinitoh_2025/src/core/achievements/achievements.dart';
import 'package:cazzinitoh_2025/src/features/achievements/presentation/widgets/achievements/achievementsListViewByIds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
  late TextEditingController _gamerTagController;
  late TextEditingController _fechaNacimientoController;

  String _profilePictureUrl = '';
  File? _pickedImageFile;
  bool _isUploading = false;

  final _formKey = GlobalKey<FormState>();
  final _picker  = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedFechaNacimiento = widget.initialData?.fechaNacimiento;
    _fechaNacimientoController = TextEditingController(
      text: _selectedFechaNacimiento != null
          ? _formatDate(_selectedFechaNacimiento!)
          : '',
    );
    _nameController     = TextEditingController(text: widget.initialData?.name ?? '');
    _emailController    = TextEditingController(text: widget.initialData?.email ?? '');
    _gamerTagController = TextEditingController(text: widget.initialData?.nameTag ?? '');
    _profilePictureUrl  = widget.initialData?.profilePictureUrl ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _gamerTagController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _handleAvatarUpload() async {  
    final source = await _showImageSourceSheet();
    if (source == null) return;

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 800,
    );
    if (picked == null) return;

    setState(() {
      _pickedImageFile = File(picked.path);
      _isUploading = true;
    });

    try {
      // final url = await uploadProfilePicture(_pickedImageFile!);
      // setState(() => _profilePictureUrl = url);
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      if (mounted) {
        AppAlert.show(
          context,
          type: AlertType.error,
          title: 'Error al subir imagen',
          message: e.toString(),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<ImageSource?> _showImageSourceSheet() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.purpleCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.purpleCardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Seleccionar imagen',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: AppColors.purpleAccent),
                title: const Text('Cámara', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.purpleAccent),
                title: const Text('Galería', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFechaNacimiento() async {
    final now     = DateTime.now();
    final initial = _selectedFechaNacimiento ?? DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Seleccioná tu fecha de nacimiento',
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.purplePrimary,
            onPrimary: Colors.white,
            surface: AppColors.purpleCard,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedFechaNacimiento = picked;
        _fechaNacimientoController.text = _formatDate(picked);
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<UpdateUserBloc>().add(
        UpdateUser(
          name: _nameController.text,
          nameTag: _gamerTagController.text,
          fechaNacimiento: _selectedFechaNacimiento ?? DateTime.now(),
          profilePictureUrl: _pickedImageFile != null ? _profilePictureUrl : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Set<int> userAchievementIds =
        (widget.initialData?.idAchievements ?? <int>[]).toSet();

    return Scaffold(
      // ── Navbar global minimalista ──────────────────────────────────────
      appBar: const AppBackNavBar(title: 'Editar Perfil'),
      extendBodyBehindAppBar: true,
      body: BlocListener<UpdateUserBloc, UpdateUserState>(
        listener: (context, state) {
          if (state is UpdateUserSuccess) {
            final updatedUser = UserModel(
              id: widget.initialData?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
              name: _nameController.text,
              nameTag: _gamerTagController.text,
              fechaNacimiento: _selectedFechaNacimiento!,
              email: widget.initialData?.email ?? '',
              profilePictureUrl: _pickedImageFile != null
                  ? _profilePictureUrl
                  : widget.initialData?.profilePictureUrl ?? '',
              idAchievements: widget.initialData?.idAchievements ?? [],
            );

            widget.onSave(updatedUser);
            AppAlert.show(
              context,
              type: AlertType.success,
              title: 'Perfil actualizado',
              message: 'Tus cambios han sido guardados exitosamente.',
            );
            context.read<UpdateUserBloc>().add(UpdateUserReset());
          } else if (state is UpdateUserFailure) {
            AppAlert.show(
              context,
              type: AlertType.error,
              title: 'Error al actualizar',
              message: state.failure.toString(),
            );
            context.read<UpdateUserBloc>().add(UpdateUserReset());
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.purpleBackground,
                AppColors.purple900,
                Color(0xFF4C1D95),
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
                          const SizedBox(height: 16),

                          // Avatar
                          _buildAvatarSection(),
                          const SizedBox(height: 20),

                          const Text(
                            'Personaliza tu experiencia de juego',
                            style: TextStyle(fontSize: 15, color: AppColors.purple300),
                          ),
                          const SizedBox(height: 32),

                          _buildFormCard(userAchievementIds),
                          const SizedBox(height: 20),

                          Text(
                            'Los cambios se aplicarán inmediatamente',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.purpleAccent.withOpacity(0.7),
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
                        color: Colors.black.withOpacity(0.6),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.purpleBorder),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Actualizando perfil...',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
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
    Widget imageContent;

    if (_pickedImageFile != null) {
      imageContent = Image.file(_pickedImageFile!, fit: BoxFit.cover);
    } else if (_profilePictureUrl.isNotEmpty) {
      imageContent = Image.network(
        _profilePictureUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _avatarPlaceholder(),
      );
    } else {
      imageContent = _avatarPlaceholder();
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.purpleBorder, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.purpleGlow.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(child: imageContent),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _isUploading ? null : _handleAvatarUpload,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.purplePrimary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.purpleBackground, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 8)],
              ),
              child: _isUploading
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.camera_alt, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder() => Container(
        color: AppColors.purple900,
        child: const Icon(Icons.person, size: 52, color: AppColors.purple300),
      );

  Widget _buildFormCard(Set<int> userAchievementIds) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.purpleCard.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.purpleBorder.withOpacity(0.3)),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 24)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: const [
                Icon(Icons.shield, size: 18, color: AppColors.purple300),
                SizedBox(width: 8),
                Text(
                  'Información Personal',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.purple300,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(
                    label: 'Nombre de Usuario',
                    icon: Icons.person,
                    controller: _nameController,
                    placeholder: 'Ingresa tu nombre',
                    required: true,
                  ),
                  const SizedBox(height: 20),

                  _buildInputField(
                    label: 'Gamer Tag',
                    icon: Icons.emoji_events,
                    controller: _gamerTagController,
                    placeholder: 'Tu identificador único',
                  ),
                  const SizedBox(height: 20),

                  _buildInputField(
                    label: 'Correo Electrónico (No modificable)',
                    controller: _emailController,
                    placeholder: 'tu@email.com',
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: _pickFechaNacimiento,
                    child: AbsorbPointer(
                      child: _buildInputField(
                        label: 'Fecha de nacimiento',
                        icon: Icons.calendar_today,
                        controller: _fechaNacimientoController,
                        placeholder: 'aaaa-mm-dd',
                        keyboardType: TextInputType.datetime,
                        suffix: const Icon(Icons.expand_more, color: AppColors.purpleAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildAchievementsSection(userAchievementIds),
                  const SizedBox(height: 28),

                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(Set<int> userAchievementIds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.purple900.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.purpleBorder.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.purplePrimary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.military_tech, size: 16, color: AppColors.purpleAccent),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mis Logros',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Tus conquistas en el desafío',
                      style: TextStyle(color: AppColors.purpleAccent, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.purplePrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${userAchievementIds.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        userAchievementIds.isEmpty
            ? _buildEmptyAchievements()
            : Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.purpleCardBorder.withOpacity(0.4)),
                ),
                clipBehavior: Clip.antiAlias,
                child: AchievementsListViewByIds(
                  userAchievementIds: userAchievementIds,
                  achievementSrc: AchievementSrc(),
                ),
              ),
      ],
    );
  }

  Widget _buildEmptyAchievements() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.purpleBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.purpleCardBorder.withOpacity(0.3),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 40,
              color: AppColors.purpleAccent.withOpacity(0.4),
            ),
            const SizedBox(height: 12),
            Text(
              'Aún no hay logros desbloqueados',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.purpleAccent.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '¡Completá desafíos para ganarlos!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: AppColors.purpleGlow.withOpacity(0.3),
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.zero,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.purplePrimary, Color(0xFF6D28D9)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_rounded, size: 18, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Guardar Cambios',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: widget.onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade300,
              side: BorderSide(color: AppColors.purpleCardBorder),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
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
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: AppColors.purple300),
              const SizedBox(width: 7),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.purple300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          validator: required
              ? (v) => (v == null || v.isEmpty) ? 'Este campo es requerido' : null
              : null,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: AppColors.purple300.withOpacity(0.4)),
            filled: true,
            fillColor: AppColors.purpleCardBorder.withOpacity(0.4),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            suffixIcon: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.purpleBorder.withOpacity(0.4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.purpleBorder.withOpacity(0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.purpleAccent, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.red500),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.purpleCardBorder.withOpacity(0.3)),
            ),
          ),
        ),
      ],
    );
  }
}