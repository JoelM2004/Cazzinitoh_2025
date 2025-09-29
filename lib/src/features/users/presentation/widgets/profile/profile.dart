import 'package:flutter/material.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';

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
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _nameTagController;
  late TextEditingController _ageController;
  late TextEditingController _gamerTagController;

  String _profilePictureUrl = '';
  bool _isUploading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialData?.name ?? '',
    );
    _emailController = TextEditingController(
      text: widget.initialData?.email ?? '',
    );
    _nameTagController = TextEditingController(
      text: widget.initialData?.nameTag ?? '',
    );
    _ageController = TextEditingController(
      text: widget.initialData?.age.toString() ?? '',
    );
    _gamerTagController = TextEditingController(
      text: widget.initialData?.nameTag ?? '', // Gamer tag similar al nombre
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
    _ageController.dispose();
    _gamerTagController.dispose();
    super.dispose();
  }

  void _handleAvatarUpload() {
    setState(() {
      _isUploading = true;
    });

    // Simular upload de imagen
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
        // En una implementación real, aquí se subiría la imagen
      }
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final userData = UserModel(
        id:
            widget.initialData?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        nameTag: _nameTagController.text,
        age: int.tryParse(_ageController.text) ?? 1,
        email: _emailController.text,
        profilePictureUrl: _profilePictureUrl,
      );

      widget.onSave(userData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 448), // max-w-md
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // Botón volver al contexto anterior
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                      style: TextStyle(fontSize: 16, color: Color(0xFFD8B4FE)),
                    ),
                    const SizedBox(height: 32),

                    // Formulario
                    _buildFormCard(),

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

  Widget _buildFormCard() {
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
                  _buildInputField(
                    label: 'Edad',
                    icon: Icons.star,
                    controller: _ageController,
                    placeholder: '1',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),

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
    bool enabled = true, // 👈 nuevo parámetro
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
          enabled: enabled, // 👈 controla si se puede editar
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
          ),
        ),
      ],
    );
  }
}
