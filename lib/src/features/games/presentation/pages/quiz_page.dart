import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:cazzinitoh_2025/src/core/quiz/quiz_data.dart';
import 'package:flutter/material.dart';

/// QuizPage — muestra UNA sola pregunta aleatoria por visita al punto.
/// Devuelve true si la respuesta fue correcta, false si no.
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  late final QuizQuestion _question;
  int? _selectedOption;
  bool _answered = false;

  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;

  @override
  void initState() {
    super.initState();
    // ── UNA sola pregunta aleatoria ────────────────────────────
    _question = QuizData.getRandom(1).first;

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _feedbackScale = CurvedAnimation(
      parent: _feedbackController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
    });
    _feedbackController.forward(from: 0);
  }

  void _finish() {
    final isCorrect = _selectedOption == _question.correctIndex;
    Navigator.pop(context, isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    final q = _question;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.purpleBackground,
              AppColors.purple900,
              Color(0xFF0d0d1a),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context, false),
                      icon: const Icon(Icons.close, color: Colors.white54),
                    ),
                    Expanded(
                      child: Text(
                        'Pregunta del punto',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Espacio simétrico al botón de cerrar
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // ── Cuerpo scrollable ────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card de la pregunta
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: AppColors.purpleCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.purpleCardBorder),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: const BoxDecoration(
                                color: AppColors.purple700,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.quiz_outlined,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              q.question,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Opciones
                      ...List.generate(q.options.length, (i) {
                        final isCorrect  = i == q.correctIndex;
                        final isSelected = i == _selectedOption;

                        Color borderColor = AppColors.purpleCardBorder;
                        Color bgColor     = AppColors.purpleCard;
                        Widget? trailing;

                        if (_answered) {
                          if (isCorrect) {
                            borderColor = Colors.green;
                            bgColor     = Colors.green.withOpacity(0.15);
                            trailing    = const Icon(Icons.check_circle,
                                color: Colors.green, size: 20);
                          } else if (isSelected) {
                            borderColor = Colors.red;
                            bgColor     = Colors.red.withOpacity(0.15);
                            trailing    = const Icon(Icons.cancel,
                                color: Colors.red, size: 20);
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => _selectOption(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borderColor, width: 1.5),
                              ),
                              child: Row(
                                children: [
                                  // Letra A / B / C / D
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _answered && isCorrect
                                          ? Colors.green
                                          : _answered && isSelected
                                              ? Colors.red
                                              : AppColors.purple700.withOpacity(0.5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + i),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      q.options[i],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                  if (trailing != null) trailing,
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 8),

                      // Feedback animado
                      if (_answered)
                        ScaleTransition(
                          scale: _feedbackScale,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _selectedOption == q.correctIndex
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedOption == q.correctIndex
                                    ? Colors.green.withOpacity(0.5)
                                    : Colors.red.withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _selectedOption == q.correctIndex
                                      ? Icons.check_circle_outline
                                      : Icons.cancel_outlined,
                                  color: _selectedOption == q.correctIndex
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _selectedOption == q.correctIndex
                                        ? '¡Correcto! Excelente.'
                                        : 'Incorrecto. Era: ${q.options[q.correctIndex]}',
                                    style: TextStyle(
                                      color: _selectedOption == q.correctIndex
                                          ? Colors.green.shade200
                                          : Colors.red.shade200,
                                      fontSize: 14,
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

              // ── Botón continuar (aparece tras responder) ─────────
              if (_answered)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _finish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Continuar →',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}