import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:flutter/material.dart';

/// Input de texto genérico con label, ícono y validación.
///
/// Ejemplos:
///   AppTextField(label: 'Nombre', controller: _ctrl, placeholder: 'Juan')
///   AppTextField.required(label: 'Nombre', controller: _ctrl, placeholder: 'Juan')
class AppTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final IconData? icon;
  final Widget? suffix;
  final bool enabled;
  final bool isRequired;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int maxLines;

  const AppTextField({
    Key? key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.icon,
    this.suffix,
    this.enabled = true,
    this.isRequired = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
  }) : super(key: key);

  /// Variante con validación de campo requerido ya incluida.
  const AppTextField.required({
    Key? key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.icon,
    this.suffix,
    this.enabled = true,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
  })  : isRequired = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(text: label, icon: icon),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          enabled: enabled,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator ??
              (isRequired
                  ? (v) => (v == null || v.trim().isEmpty) ? 'Este campo es requerido' : null
                  : null),
          decoration: _buildDecoration(),
        ),
      ],
    );
  }

  InputDecoration _buildDecoration() => InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(color: AppColors.purple300.withOpacity(0.4)),
        filled: true,
        fillColor: enabled
            ? AppColors.purpleCardBorder.withOpacity(0.4)
            : AppColors.purpleCardBorder.withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        suffixIcon: suffix,
        border: _border(AppColors.purpleBorder.withOpacity(0.4)),
        enabledBorder: _border(AppColors.purpleBorder.withOpacity(0.4)),
        focusedBorder: _border(AppColors.purpleAccent, width: 1.5),
        errorBorder: _border(AppColors.red500),
        focusedErrorBorder: _border(AppColors.red500, width: 1.5),
        disabledBorder: _border(AppColors.purpleCardBorder.withOpacity(0.3)),
      );

  OutlineInputBorder _border(Color color, {double width = 1.0}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: width),
      );
}

// ─── Shared label widget ──────────────────────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  final IconData? icon;

  const _Label({required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 15, color: AppColors.purple300),
          const SizedBox(width: 7),
        ],
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.purple300,
          ),
        ),
      ],
    );
  }
}
