import 'package:flutter/material.dart';
import 'package:cazzinitoh_2025/src/app/theme.dart'; // ajustá el path si es distinto

enum AlertType { success, error, warning, info }

class AppAlert extends StatefulWidget {
  final AlertType type;
  final String message;
  final String? title;
  final Duration duration;
  final VoidCallback? onDismiss;

  const AppAlert({
    Key? key,
    required this.type,
    required this.message,
    this.title,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
  }) : super(key: key);

  @override
  State<AppAlert> createState() => _AppAlertState();

  // ─── Helper estático para mostrarlo como overlay ───────────────────────────
  static void show(
    BuildContext context, {
    required AlertType type,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _AlertOverlay(
        type: type,
        message: message,
        title: title,
        duration: duration,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

// ─── Overlay wrapper que maneja la animación y el auto-dismiss ─────────────
class _AlertOverlay extends StatefulWidget {
  final AlertType type;
  final String message;
  final String? title;
  final Duration duration;
  final VoidCallback onDismiss;

  const _AlertOverlay({
    required this.type,
    required this.message,
    required this.title,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_AlertOverlay> createState() => _AlertOverlayState();
}

class _AlertOverlayState extends State<_AlertOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(widget.duration, () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: AppAlert(
              type: widget.type,
              message: widget.message,
              title: widget.title,
              onDismiss: () async {
                await _controller.reverse();
                widget.onDismiss();
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─── El widget de alerta en sí ────────────────────────────────────────────
class _AppAlertState extends State<AppAlert> {
  _AlertConfig get _config => _alertConfig[widget.type]!;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _config.bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _config.borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _config.shadowColor.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícono
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _config.iconBgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(_config.icon, color: _config.iconColor, size: 18),
          ),
          const SizedBox(width: 12),

          // Texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.title != null) ...[
                  Text(
                    widget.title!,
                    style: TextStyle(
                      color: _config.titleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  widget.message,
                  style: TextStyle(
                    color: _config.messageColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Botón cerrar
          if (widget.onDismiss != null)
            GestureDetector(
              onTap: widget.onDismiss,
              child: Icon(
                Icons.close_rounded,
                color: _config.iconColor.withOpacity(0.6),
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Configuraciones por tipo ─────────────────────────────────────────────
class _AlertConfig {
  final Color bgColor;
  final Color borderColor;
  final Color shadowColor;
  final Color iconBgColor;
  final Color iconColor;
  final Color titleColor;
  final Color messageColor;
  final IconData icon;

  const _AlertConfig({
    required this.bgColor,
    required this.borderColor,
    required this.shadowColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.titleColor,
    required this.messageColor,
    required this.icon,
  });
}

const _alertConfig = <AlertType, _AlertConfig>{
  AlertType.success: _AlertConfig(
    bgColor: Color(0xFF0f2a1a),
    borderColor: Color(0xFF166534),
    shadowColor: Color(0xFF22c55e),
    iconBgColor: Color(0xFF14532d),
    iconColor: Color(0xFF4ade80),
    titleColor: Color(0xFF86efac),
    messageColor: Color(0xFFbbf7d0),
    icon: Icons.check_circle_rounded,
  ),
  AlertType.error: _AlertConfig(
    bgColor: Color(0xFF2a0f0f),
    borderColor: Color(0xFF991b1b),
    shadowColor: Color(0xFFef4444),
    iconBgColor: Color(0xFF7f1d1d),
    iconColor: Color(0xFFf87171),
    titleColor: Color(0xFFfca5a5),
    messageColor: Color(0xFFfecaca),
    icon: Icons.cancel_rounded,
  ),
  AlertType.warning: _AlertConfig(
    bgColor: Color(0xFF2a1f0a),
    borderColor: Color(0xFF92400e),
    shadowColor: Color(0xFFf59e0b),
    iconBgColor: Color(0xFF78350f),
    iconColor: Color(0xFFfbbf24),
    titleColor: Color(0xFFfcd34d),
    messageColor: Color(0xFFfde68a),
    icon: Icons.warning_rounded,
  ),
  AlertType.info: _AlertConfig(
    // Usa los colores purple del app
    bgColor: Color(0xFF1a0f2a),
    borderColor: AppColors.purpleBorder,   // desde el theme
    shadowColor: AppColors.purple500,
    iconBgColor: Color(0xFF3b0764),
    iconColor: AppColors.purple400,
    titleColor: AppColors.purple300,
    messageColor: Color(0xFFe9d5ff),
    icon: Icons.info_rounded,
  ),
};
