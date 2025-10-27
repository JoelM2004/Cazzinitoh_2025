import 'package:cazzinitoh_2025/src/features/users/presentation/pages/home_page.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/pages/menu_page.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextEditingController _answerController = TextEditingController();
  bool? _isCorrect;

  final Map<String, dynamic> riddle = {
    'question': 'VIVO DEL BAMBÚ Y TENGO UNA PELÍCULA',
    'correctAnswer': 'sombra',
    'hint': 'Pista: Me proyectas sin querer...',
  };

  @override
  void initState() {
    super.initState();
    // Agregar listener para actualizar el estado cuando cambie el texto
    _answerController.addListener(() {
      setState(() {});
    });
  }

  void _handleSubmit() {
    final userAnswer = _answerController.text.toLowerCase().trim();
    final correct = userAnswer == riddle['correctAnswer'];

    setState(() {
      _isCorrect = correct;
    });

    if (correct) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _answerController.clear();
          _isCorrect = null;
        });
        // Aquí podrías cargar el siguiente acertijo
      });
    }
  }

  void _showHint() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2937),
          title: const Text('💡 Pista', style: TextStyle(color: Colors.white)),
          content: Text(
            riddle['hint'],
            style: const TextStyle(color: Color(0xFFD8B4FE)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _goBack() {
    // Verifica si hay una pantalla anterior
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      // Si no hay pantalla anterior, navegar a la pantalla de inicio
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MenuPage()),
      );
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
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
              Color(0xFF581C87), // purple-900
              Color(0xFF6B21A8), // purple-800
              Color(0xFF4C1D95), // indigo-900
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Botón de volver atrás
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: _goBack,
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          tooltip: 'Volver',
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Header
                      _buildHeader(),
                      const SizedBox(height: 32),
                      // Riddle Card
                      _buildRiddleCard(),
                      const SizedBox(height: 24),
                      // Answer Input
                      _buildAnswerInput(),
                      const SizedBox(height: 24),
                      // Submit Button
                      _buildSubmitButton(),
                      const SizedBox(height: 24),
                      // Feedback
                      if (_isCorrect != null) _buildFeedback(),
                      const SizedBox(height: 16),
                      // Hint Button
                      if (_isCorrect != true) _buildHintButton(),
                    ],
                  ),
                ),
              ),
              // Progress Indicator
              _buildProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFC084FC), width: 4),
          ),
          child: ClipOval(
            child: Image.network(
              'https://radiomasterlujan.com.ar/wp-content/uploads/2022/11/20221120_141751.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF6B21A8),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Memory Trip',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Desafía tu mente',
          style: TextStyle(color: Color(0xFFD8B4FE), fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRiddleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFA855F7).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF9333EA),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Acertijo #1',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            riddle['question'],
            style: const TextStyle(
              color: Color(0xFFD1D5DB),
              fontSize: 18,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tu respuesta:',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _answerController,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            hintText: 'Escribe tu respuesta aquí...',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 18),
            filled: true,
            fillColor: const Color(0xFF1F2937),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFA855F7), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: const Color(0xFFA855F7).withOpacity(0.5),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFC084FC), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          onSubmitted: (_) {
            if (_answerController.text.trim().isNotEmpty) {
              _handleSubmit();
            }
          },
        ),
        const SizedBox(height: 8),
        const Text(
          'Presiona Enter o el botón para confirmar tu respuesta',
          style: TextStyle(color: Color(0xFFD8B4FE), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final isEnabled = _answerController.text.trim().isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? _handleSubmit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? const Color(0xFF9333EA)
              : const Color(0xFF4B5563),
          disabledBackgroundColor: const Color(0xFF4B5563),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, size: 20),
            SizedBox(width: 8),
            Text(
              'Confirmar Respuesta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    final isCorrect = _isCorrect == true;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? const Color(0xFF14532D).withOpacity(0.8)
            : const Color(0xFF7F1D1D).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect
              ? const Color(0xFF22C55E).withOpacity(0.5)
              : const Color(0xFFEF4444).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: isCorrect
                ? const Color(0xFF86EFAC)
                : const Color(0xFFFCA5A5),
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            isCorrect
                ? '¡Correcto! Excelente deducción.'
                : 'Incorrecto. ¡Inténtalo de nuevo!',
            style: TextStyle(
              color: isCorrect
                  ? const Color(0xFF86EFAC)
                  : const Color(0xFFFCA5A5),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: _showHint,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: const Color(0xFFA855F7).withOpacity(0.5),
            width: 1,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          foregroundColor: const Color(0xFFD8B4FE),
        ),
        child: const Text('💡 Obtener Pista', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Progreso:',
            style: TextStyle(color: Color(0xFFD8B4FE), fontSize: 14),
          ),
          const SizedBox(width: 8),
          Container(
            width: 128,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF374151),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.25,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA855F7), Color(0xFFEF4444)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '1/4',
            style: TextStyle(color: Color(0xFFD8B4FE), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
