import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/help/tutorial_stepcard.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tutorialSteps = [
      {
        'id': 1,
        'icon': Icons.location_on,
        'title': 'Visita las Ubicaciones',
        'description':
            'Recorre 3 o más ubicaciones en el mapa siguiendo el orden indicado. Cada punto te guiará al siguiente destino.',
        'color': const Color(0xFFA855F7), // purple-400
      },
      {
        'id': 2,
        'icon': Icons.access_time,
        'title': 'Tiempo Límite',
        'description':
            '¡Apúrateeee! Los puntos de destino tienen un tiempo límite de visualización.',
        'color': const Color(0xFFF87171), // red-400
      },
      {
        'id': 3,
        'icon': Icons.extension,
        'title': 'Resuelve el Acertijo',
        'description':
            'Al llegar a la ubicación final, se revelará un acertijo misterioso que deberás resolver para continuar.',
        'color': const Color(0xFFA855F7), // purple-400
      },
      {
        'id': 4,
        'icon': Icons.emoji_events,
        'title': 'Tabla de Puntuación',
        'description':
            'Completa el desafío y accede al leaderboard para ver tu posición entre los mejores jugadores.',
        'color': const Color(0xFFEAB308), // yellow-500
      },
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A), // slate-900
              Color(0xFF581C87), // purple-950
              Color(0xFF0F172A), // slate-900
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  children: [
                    // Back button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF9CA3AF),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    // Title
                    const Expanded(
                      child: Text(
                        'Cómo Jugar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE9D5FF), // purple-200
                        ),
                      ),
                    ),
                    // Spacer
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Introduction
                      const Padding(
                        padding: EdgeInsets.only(bottom: 32),
                        child: Text(
                          'Bienvenido al desafío. Sigue estos pasos para dominar el juego y convertirte en leyenda.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFD1D5DB),
                            height: 1.5,
                          ),
                        ),
                      ),

                      // Tutorial Steps
                      ...tutorialSteps.map((step) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: TutorialStepCard(
                            stepNumber: step['id'] as int,
                            icon: step['icon'] as IconData,
                            title: step['title'] as String,
                            description: step['description'] as String,
                            iconColor: step['color'] as Color,
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 16),

                      // Tips Section
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              const Color(
                                0xFF581C87,
                              ).withOpacity(0.5), // purple-900/50
                              const Color(
                                0xFF7F1D1D,
                              ).withOpacity(0.5), // red-900/50
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF7C3AED),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '💡 Consejos Estratégicos',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE9D5FF), // purple-200
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildTipItem(
                              'Planifica tu ruta antes de comenzar para optimizar el tiempo',
                            ),
                            const SizedBox(height: 8),
                            _buildTipItem(
                              'Mantén la atención en el temporizador durante tu recorrido',
                            ),
                            const SizedBox(height: 8),
                            _buildTipItem(
                              'Los acertijos pueden requerir observación del entorno',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Action Buttons
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navegar al desafío
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: const Color(
                              0xFF581C87,
                            ).withOpacity(0.5),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.play_arrow, size: 20),
                                  SizedBox(width: 12),
                                  Text(
                                    'Comenzar Desafío',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD1D5DB),
                            side: const BorderSide(color: Color(0xFF4B5563)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Volver al Menú Principal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Footer Note
                      Container(
                        padding: const EdgeInsets.only(top: 24),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFF374151), width: 1),
                          ),
                        ),
                        child: const Text(
                          '¿Necesitas más ayuda? Consulta la sección de preguntas frecuentes en el menú.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            '•',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFA855F7), // purple-400
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Color(0xFFD1D5DB)),
          ),
        ),
      ],
    );
  }
}
