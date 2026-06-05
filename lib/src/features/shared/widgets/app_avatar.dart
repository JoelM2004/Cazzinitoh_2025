import 'dart:io';
import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Avatar circular con opción de editar foto.
///
/// Modo solo lectura (sin botón cámara):
///   AppAvatar(imageUrl: user.profilePictureUrl)
///
/// Modo editable (con upload):
///   AppAvatar.editable(
///     imageUrl: _profilePictureUrl,
///     pickedFile: _pickedImageFile,
///     isUploading: _isUploading,
///     onImagePicked: (file) { /* guardá el file y subilo */ },
///   )
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final File? pickedFile;
  final bool isUploading;
  final bool editable;
  final double size;
  final ValueChanged<File>? onImagePicked;

  const AppAvatar({
    Key? key,
    this.imageUrl,
    this.pickedFile,
    this.size = 128,
    this.isUploading = false,
    this.editable = false,
    this.onImagePicked,
  }) : super(key: key);

  /// Variante editable con image picker integrado.
  const AppAvatar.editable({
    Key? key,
    this.imageUrl,
    this.pickedFile,
    required this.onImagePicked,
    this.size = 128,
    this.isUploading = false,
  })  : editable = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Ring con glow ─────────────────────────────────────────────────
        Container(
          width: size,
          height: size,
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
          child: ClipOval(child: _resolveImage()),
        ),

        // ── Botón cámara (solo si editable) ──────────────────────────────
        if (editable)
          Positioned(
            bottom: 0,
            right: 0,
            child: _CameraButton(
              isUploading: isUploading,
              onTap: () => _handlePick(context),
            ),
          ),
      ],
    );
  }

  Widget _resolveImage() {
    if (pickedFile != null) {
      return Image.file(pickedFile!, fit: BoxFit.cover);
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _Placeholder(),
      );
    }
    return _Placeholder();
  }

  Future<void> _handlePick(BuildContext context) async {
    if (isUploading) return;

    final source = await _showSourceSheet(context);
    if (source == null) return;

    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 800,
    );
    if (picked != null) onImagePicked?.call(File(picked.path));
  }

  Future<ImageSource?> _showSourceSheet(BuildContext context) {
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
                width: 40,
                height: 4,
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
                leading: const Icon(Icons.photo_camera_rounded, color: AppColors.purpleAccent),
                title: const Text('Cámara', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppColors.purpleAccent),
                title: const Text('Galería', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Subwidgets privados ──────────────────────────────────────────────────────

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.purple900,
        child: const Icon(Icons.person_rounded, size: 52, color: AppColors.purple300),
      );
}

class _CameraButton extends StatelessWidget {
  final bool isUploading;
  final VoidCallback onTap;

  const _CameraButton({required this.isUploading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUploading ? null : onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.purplePrimary,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.purpleBackground, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 8)],
        ),
        child: isUploading
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.camera_alt_rounded, size: 18, color: Colors.white),
      ),
    );
  }
}
