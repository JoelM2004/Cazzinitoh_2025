import 'package:cazzinitoh_2025/src/app/routes.dart';
import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:cazzinitoh_2025/src/features/shared/widgets/shared_widgets.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/help/tutorial_stepcard.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  static const _steps = [
    (
      id: 1,
      icon: Icons.location_on_rounded,
      title: 'Visita las Ubicaciones',
      description:
          'Recorrés 3 o más ubicaciones en el mapa siguiendo el orden indicado. Cada punto te guiará al siguiente destino.',
      color: AppColors.purpleAccent,
    ),
    (
      id: 2,
      icon: Icons.timer_rounded,
      title: 'Tiempo Límite',
      description:
          '¡Apurate! Los puntos de destino tienen un tiempo límite de visualización. No te distraigas.',
      color: AppColors.red400,
    ),
    (
      id: 3,
      icon: Icons.extension_rounded,
      title: 'Resolvé el Acertijo',
      description:
          'Al llegar a la ubicación final se revelará un acertijo misterioso que deberás resolver para continuar.',
      color: AppColors.purpleAccent,
    ),
    (
      id: 4,
      icon: Icons.emoji_events_rounded,
      title: 'Tabla de Puntuación',
      description:
          'Completá el desafío y accedé al leaderboard para ver tu posición entre los mejores jugadores.',
      color: Color(0xFFEAB308),
    ),
  ];

  static const _tips = [
    'Planificá tu ruta antes de comenzar para optimizar el tiempo.',
    'Mantené la atención en el temporizador durante tu recorrido.',
    'Los acertijos pueden requerir observación del entorno.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── Navbar ────────────────────────────────────────────────────────────
      appBar: const AppBackNavBar(title: 'Cómo Jugar'),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A), // slate-900
              AppColors.purple900,
              Color(0xFF0F172A), // slate-900
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Intro ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Seguí estos pasos para dominar el desafío y convertirte en leyenda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.72),
                      height: 1.6,
                    ),
                  ),
                ),

                // ── Steps ────────────────────────────────────────────────
                ...HelpPage._steps.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TutorialStepCard(
                      stepNumber: s.id,
                      icon: s.icon,
                      title: s.title,
                      description: s.description,
                      iconColor: s.color,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Tips ─────────────────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.purple900.withOpacity(0.55),
                        AppColors.red700.withOpacity(0.25),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.purpleBorder.withOpacity(0.5),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.purplePrimary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.lightbulb_rounded,
                              size: 16,
                              color: AppColors.purpleAccent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Consejos Estratégicos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.purple300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ...HelpPage._tips.map(
                        (tip) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _TipItem(text: tip),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── Botones ──────────────────────────────────────────────
                AppButton.primary(
                  label: 'Comenzar Desafío',
                  icon: Icons.play_arrow_rounded,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.game),
                  height: 54,
                ),
                const SizedBox(height: 12),
                AppButton.outline(
                  label: 'Volver al Menú Principal',
                  onPressed: () => Navigator.of(context).pop(),
                  height: 48,
                ),

                const SizedBox(height: 32),

                // ── Footer ───────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.purpleCardBorder.withOpacity(0.5),
                      ),
                    ),
                  ),
                  child: Text(
                    '¿Necesitás más ayuda? Consultá la sección de preguntas frecuentes en el menú.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.35),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Ítem de tip ─────────────────────────────────────────────────────────────
class _TipItem extends StatelessWidget {
  final String text;
  const _TipItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.purpleAccent,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.65),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}