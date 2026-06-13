import 'package:cazzinitoh_2025/src/features/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

/// Input de email con validación de formato incorporada.
///
/// Ejemplo:
///   AppEmailField(controller: _emailCtrl)
///   AppEmailField(controller: _emailCtrl, label: 'Correo de recuperación')
class AppEmailField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final bool enabled;
  final bool showIcon;
  final Color? focusBorderColor;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const AppEmailField({
    Key? key,
    required this.controller,
    this.label = 'Correo Electrónico',
    this.placeholder = 'tu@email.com',
    this.enabled = true,
    this.showIcon = true,
    this.focusBorderColor,
    this.textInputAction,
    this.onSubmitted,
  }) : super(key: key);

  /// Variante de solo lectura (ej: email no modificable en perfil).
  const AppEmailField.readOnly({
    Key? key,
    required this.controller,
    this.label = 'Correo Electrónico (No modificable)',
    this.placeholder = 'tu@email.com',
    this.showIcon = true,
    this.focusBorderColor,
    this.textInputAction,
    this.onSubmitted,
  })  : enabled = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      placeholder: placeholder,
      controller: controller,
      icon: showIcon ? Icons.alternate_email_rounded : null,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction ?? TextInputAction.next,
      onSubmitted: onSubmitted,
      validator: enabled ? _validateEmail : null,
    );
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Por favor ingresá tu email';
    
    // Modificado para aceptar múltiples subdominios o terminaciones de país
    final emailRegex = RegExp(r'^[\w\.\+\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    
    if (!emailRegex.hasMatch(v.trim())) return 'Ingresá un email válido';
    return null;
  }
}
