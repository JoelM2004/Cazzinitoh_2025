// lib/src/core/quiz/quiz_data.dart

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class QuizData {
  static final List<QuizQuestion> questions = [
    QuizQuestion(
      question: '¿En qué año fue fundada Caleta Olivia?',
      options: ['1901', '1913', '1921', '1935'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '¿Sobre qué recurso natural se desarrolló principalmente Caleta Olivia?',
      options: ['Pesca', 'Minería de plata', 'Petróleo', 'Agricultura'],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: '¿Qué empresa estatal fue clave en el desarrollo de Caleta Olivia?',
      options: ['ENTEL', 'YPF', 'Aerolíneas Argentinas', 'SEGBA'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '¿En qué provincia argentina se encuentra Caleta Olivia?',
      options: ['Chubut', 'Tierra del Fuego', 'Santa Cruz', 'Neuquén'],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: '¿Cuál es el monumento más icónico de Caleta Olivia?',
      options: [
        'El Tehuelche',
        'El Obrero Petrolero (El Gorosito)',
        'La Ballena Azul',
        'El Pingüino de Magallanes',
      ],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '¿Cómo se conoce popularmente al Monumento al Obrero Petrolero?',
      options: ['El Petroquero', 'El Gorosito', 'El Barrenador', 'El Roustabout'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '¿En qué año se inauguró el Monumento al Obrero Petrolero?',
      options: ['1955', '1963', '1969', '1975'],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: '¿Qué fecha da nombre al Barrio 26 de Junio de Caleta Olivia?',
      options: [
        'Fundación de la ciudad',
        'Descubrimiento de petróleo en el pozo O-12',
        'Inauguración del puerto',
        'Llegada del ferrocarril',
      ],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '¿En qué año se inauguró la Capilla Cristo Obrero, primera iglesia de Caleta Olivia?',
      options: ['1950', '1963', '1971', '1980'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '¿En qué año fue declarada Patrimonio Cultural la Capilla Cristo Obrero?',
      options: ['1995', '1999', '2004', '2010'],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: '¿Cuándo se fundó la primera escuela permanente de Caleta Olivia?',
      options: ['1910', '1922', '1930', '1945'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '¿Cuál fue el primer conjunto habitacional de YPF en Caleta Olivia?',
      options: ['Barrio 26 de Junio', 'Barrio Parque', 'Barrio Norte', 'Barrio Petrolero'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '¿Cómo se conocía antes al Barrio Parque?',
      options: ['Barrio nuevo', 'Barrio viejo', 'Barrio YPF', 'Barrio central'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '¿Cómo se conoce popularmente al Barrio 26 de Junio?',
      options: ['Barrio viejo', 'Barrio nuevo', 'Barrio sur', 'Barrio YPF'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '¿En qué año se inauguró el Hospital Meprisa?',
      options: ['1955', '1963', '1970', '1978'],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '¿Qué significa MEPRISA?',
      options: [
        'Medicina Privada Santa Cruz',
        'Empresa formada principalmente por ex empleados de YPF',
        'Hospital Municipal de Caleta',
        'Centro Médico Regional',
      ],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: '¿En qué año fue privatizado el Hospital de YPF como MEPRISA?',
      options: ['1985', '1989', '1992', '1995'],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: '¿A orillas de qué golfo se encuentra Caleta Olivia?',
      options: ['Golfo San Jorge', 'Golfo San Matías', 'Golfo Nuevo', 'Golfo Almirante'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: '¿Con qué ciudad patagónica importante limita Caleta Olivia al norte?',
      options: ['Comodoro Rivadavia', 'Puerto Madryn', 'Río Gallegos', 'Pico Truncado'],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: '¿Qué tipo de sistema de crédito usaban en el Almacén de Juan Álvarez?',
      options: [
        'Pago con trueque',
        'Libreta de crédito mensual',
        'Pago adelantado',
        'Descuento de sueldo',
      ],
      correctIndex: 1,
    ),
  ];

  /// Devuelve [count] preguntas aleatorias sin repetir
  static List<QuizQuestion> getRandom(int count) {
    final shuffled = List<QuizQuestion>.from(questions)..shuffle();
    return shuffled.take(count.clamp(1, questions.length)).toList();
  }
}