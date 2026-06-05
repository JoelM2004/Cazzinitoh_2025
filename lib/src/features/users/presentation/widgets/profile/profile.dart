import 'dart:io';
import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:cazzinitoh_2025/src/features/shared/widgets/shared_widgets.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/update_user/update_user_bloc.dart';
import 'package:cazzinitoh_2025/src/core/achievements/achievements.dart';
import 'package:cazzinitoh_2025/src/features/achievements/presentation/widgets/achievements/achievementsListViewByIds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  String _profilePictureUrl = '';
  File? _pickedImageFile;
  bool _isUploading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedFechaNacimiento = widget.initialData?.fechaNacimiento;
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
    super.dispose();
  }

  Future<void> _onImagePicked(File file) async {
  setState(() {
    _pickedImageFile = file;
  });
}

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<UpdateUserBloc>().add(
        UpdateUser(
          name: _nameController.text,
          nameTag: _gamerTagController.text,
          fechaNacimiento: _selectedFechaNacimiento ?? DateTime.now(),
          profilePictureUrl: _pickedImageFile?.path,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Set<int> userAchievementIds =
        (widget.initialData?.idAchievements ?? <int>[]).toSet();

    return Scaffold(
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
            AppAlert.show(context, type: AlertType.success, title: 'Perfil actualizado', message: 'Tus cambios han sido guardados exitosamente.');
            context.read<UpdateUserBloc>().add(UpdateUserReset());
          } else if (state is UpdateUserFailure) {
            AppAlert.show(context, type: AlertType.error, title: 'Error al actualizar', message: state.failure.message);
            context.read<UpdateUserBloc>().add(UpdateUserReset());
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.purpleBackground, AppColors.purple900, Color(0xFF4C1D95)],
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

                          // ── Avatar ───────────────────────────────────
                          AppAvatar.editable(
                            imageUrl: _profilePictureUrl,
                            pickedFile: _pickedImageFile,
                            isUploading: _isUploading,
                            onImagePicked: _onImagePicked,
                          ),
                          const SizedBox(height: 20),

                          const Text(
                            'Personalizá tu experiencia de juego',
                            style: TextStyle(fontSize: 15, color: AppColors.purple300),
                          ),
                          const SizedBox(height: 32),

                          // ── Form card ────────────────────────────────
                          _buildFormCard(userAchievementIds),
                          const SizedBox(height: 20),

                          Text(
                            'Los cambios se aplicarán inmediatamente',
                            style: TextStyle(fontSize: 13, color: AppColors.purpleAccent.withOpacity(0.7)),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Loading overlay ──────────────────────────────────
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
                              Text('Actualizando perfil...', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
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
          // Card header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: const [
                Icon(Icons.shield, size: 18, color: AppColors.purple300),
                SizedBox(width: 8),
                Text(
                  'Información Personal',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.purple300),
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
                  AppTextField.required(
                    label: 'Nombre de Usuario',
                    placeholder: 'Ingresá tu nombre',
                    controller: _nameController,
                    icon: Icons.person_rounded,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  AppTextField(
                    label: 'Gamer Tag',
                    placeholder: 'Tu identificador único',
                    controller: _gamerTagController,
                    icon: Icons.emoji_events_rounded,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  AppEmailField.readOnly(controller: _emailController),
                  const SizedBox(height: 20),

                  AppDateField(
                    label: 'Fecha de nacimiento',
                    selected: _selectedFechaNacimiento,
                    onChanged: (d) => setState(() => _selectedFechaNacimiento = d),
                  ),
                  const SizedBox(height: 32),

                  _buildAchievementsSection(userAchievementIds),
                  const SizedBox(height: 28),

                  // ── Botones ──────────────────────────────────────────
                  AppButton.primary(
                    label: 'Guardar Cambios',
                    icon: Icons.save_rounded,
                    onPressed: _handleSubmit,
                  ),
                  const SizedBox(height: 12),
                  AppButton.outline(
                    label: 'Cancelar',
                    onPressed: widget.onCancel,
                  ),
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
                    Text('Mis Logros', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                    Text('Tus conquistas en el desafío', style: TextStyle(color: AppColors.purpleAccent, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.purplePrimary, borderRadius: BorderRadius.circular(20)),
                child: Text('${userAchievementIds.length}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
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
        border: Border.all(color: AppColors.purpleCardBorder.withOpacity(0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 40, color: AppColors.purpleAccent.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text(
              'Aún no hay logros desbloqueados',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.purpleAccent.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              '¡Completá desafíos para ganarlos!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}