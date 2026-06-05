import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:flutter/material.dart';

/// Botón primario con gradiente violeta.
///
/// Ejemplo:
///   AppButton.primary(label: 'Guardar', onPressed: _save, icon: Icons.save)
///   AppButton.primary(label: 'Cargando...', onPressed: null, isLoading: true)
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double height;
  final _ButtonVariant _variant;

  // ── Constructores por variante ────────────────────────────────────────────

  /// Gradiente violeta — acción principal.
  const AppButton.primary({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height = 50,
  })  : _variant = _ButtonVariant.primary,
        super(key: key);

  /// Relleno rojo — acción destructiva / registro.
  const AppButton.destructive({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height = 50,
  })  : _variant = _ButtonVariant.destructive,
        super(key: key);

  /// Sin relleno, borde sutil — cancelar / acción secundaria.
  const AppButton.outline({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height = 50,
  })  : _variant = _ButtonVariant.outline,
        super(key: key);

  /// Fondo semitransparente violeta — acciones de soporte.
  const AppButton.ghost({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height = 50,
  })  : _variant = _ButtonVariant.ghost,
        super(key: key);

  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: _variant == _ButtonVariant.primary
          ? _PrimaryButton(
              label: label,
              onPressed: onPressed,
              icon: icon,
              isLoading: isLoading,
            )
          : _variant == _ButtonVariant.destructive
              ? _DestructiveButton(
                  label: label,
                  onPressed: onPressed,
                  icon: icon,
                  isLoading: isLoading,
                )
              : _variant == _ButtonVariant.outline
                  ? _OutlineButton(
                      label: label,
                      onPressed: onPressed,
                      icon: icon,
                      isLoading: isLoading,
                    )
                  : _GhostButton(
                      label: label,
                      onPressed: onPressed,
                      icon: icon,
                      isLoading: isLoading,
                    ),
    );
  }
}

enum _ButtonVariant { primary, destructive, outline, ghost }

// ─── Primary (gradiente violeta) ─────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (isLoading || onPressed == null) ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        disabledBackgroundColor: Colors.transparent,
        shadowColor: AppColors.purpleGlow.withOpacity(0.3),
        elevation: onPressed != null ? 8 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.zero,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: onPressed != null
                ? [AppColors.purplePrimary, const Color(0xFF6D28D9)]
                : [AppColors.purplePrimary.withOpacity(0.4), const Color(0xFF6D28D9).withOpacity(0.4)],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: Colors.white),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─── Destructive (rojo) ──────────────────────────────────────────────────────
class _DestructiveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const _DestructiveButton({
    required this.label,
    required this.onPressed,
    this.icon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (isLoading || onPressed == null) ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.red700,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.red700.withOpacity(0.4),
        elevation: 8,
        shadowColor: AppColors.red500.withOpacity(0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
    );
  }
}

// ─── Outline (borde sutil) ───────────────────────────────────────────────────
class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const _OutlineButton({
    required this.label,
    required this.onPressed,
    this.icon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: (isLoading || onPressed == null) ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.grey.shade300,
        side: BorderSide(color: AppColors.purpleCardBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
    );
  }
}

// ─── Ghost (semitransparente) ─────────────────────────────────────────────────
class _GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const _GhostButton({
    required this.label,
    required this.onPressed,
    this.icon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (isLoading || onPressed == null) ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purplePrimary.withOpacity(0.15),
        foregroundColor: AppColors.purpleAccent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.purpleBorder.withOpacity(0.4)),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.purpleAccent),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: AppColors.purpleAccent),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.purpleAccent,
                  ),
                ),
              ],
            ),
    );
  }
}
