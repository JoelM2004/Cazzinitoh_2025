import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:flutter/material.dart';

/// Input de contraseña con toggle de visibilidad y validación configurable.
///
/// Ejemplos:
///   AppPasswordField(controller: _passCtrl)
///   AppPasswordField.confirm(controller: _confirmCtrl, originalController: _passCtrl)
///   AppPasswordField(controller: _passCtrl, accentColor: AppColors.red500)  // para registro
class AppPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final bool validateMinLength;
  final int minLength;
  final TextEditingController? originalController; // para validar confirmación
  final Color accentColor;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const AppPasswordField({
    Key? key,
    required this.controller,
    this.label = 'Contraseña',
    this.placeholder = '••••••••',
    this.validateMinLength = false,
    this.minLength = 8,
    this.originalController,
    this.accentColor = AppColors.purpleAccent,
    this.textInputAction,
    this.onSubmitted,
  }) : super(key: key);

  /// Variante para el campo "Confirmar contraseña".
  /// Valida automáticamente que coincida con [originalController].
  const AppPasswordField.confirm({
    Key? key,
    required this.controller,
    required TextEditingController original,
    this.label = 'Confirmar Contraseña',
    this.placeholder = '••••••••',
    this.accentColor = AppColors.purpleAccent,
    this.textInputAction,
    this.onSubmitted,
  })  : validateMinLength = false,
        minLength = 8,
        originalController = original,
        super(key: key);

  /// Variante para registro — activa validación de longitud mínima.
  const AppPasswordField.register({
    Key? key,
    required this.controller,
    this.label = 'Contraseña',
    this.placeholder = '••••••••',
    this.minLength = 8,
    this.accentColor = AppColors.purpleAccent,
    this.textInputAction,
    this.onSubmitted,
  })  : validateMinLength = true,
        originalController = null,
        super(key: key);

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _visible = false;

  String? _validate(String? v) {
    if (v == null || v.isEmpty) return 'Por favor ingresá tu contraseña';
    if (widget.validateMinLength && v.length < widget.minLength) {
      return 'Mínimo ${widget.minLength} caracteres';
    }
    if (widget.originalController != null && v != widget.originalController!.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Icon(
              widget.originalController != null
                  ? Icons.lock_outline_rounded
                  : Icons.lock_rounded,
              size: 15,
              color: AppColors.purple300,
            ),
            const SizedBox(width: 7),
            Text(
              widget.label,
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
          controller: widget.controller,
          obscureText: !_visible,
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          onFieldSubmitted: widget.onSubmitted,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          validator: _validate,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: TextStyle(color: AppColors.purple300.withOpacity(0.4)),
            filled: true,
            fillColor: AppColors.purpleCardBorder.withOpacity(0.4),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _visible = !_visible),
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  _visible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  size: 20,
                  color: AppColors.purple300.withOpacity(0.6),
                ),
              ),
            ),
            border: _border(AppColors.purpleBorder.withOpacity(0.4)),
            enabledBorder: _border(AppColors.purpleBorder.withOpacity(0.4)),
            focusedBorder: _border(widget.accentColor, width: 1.5),
            errorBorder: _border(AppColors.red500),
            focusedErrorBorder: _border(AppColors.red500, width: 1.5),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1.0}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: width),
      );
}
