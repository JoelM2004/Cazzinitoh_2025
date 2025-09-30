import 'package:cazzinitoh_2025/src/features/points/presentation/widgets/point/AudioButton.dart';
import 'package:cazzinitoh_2025/src/features/points/presentation/widgets/point/DistanceIndicator.dart';
import 'package:cazzinitoh_2025/src/features/points/presentation/widgets/point/ImageGallery.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:flutter/material.dart';

class DestinationDetailScreen extends StatefulWidget {
  final Point point;
  const DestinationDetailScreen({Key? key, required this.point})
    : super(key: key);

  @override
  State<DestinationDetailScreen> createState() =>
      _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _infoCardController;
  late AnimationController _castleController;
  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerOffset;
  late Animation<double> _infoCardOpacity;
  late Animation<Offset> _infoCardOffset;
  late Animation<double> _castleRotation;
  late Animation<double> _castleScale;

  @override
  void initState() {
    super.initState();

    // Header animation
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _headerOffset =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
        );

    // Info card animation
    _infoCardController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _infoCardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _infoCardController, curve: Curves.easeOut),
    );

    _infoCardOffset =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _infoCardController, curve: Curves.easeOut),
        );

    // Castle icon animation
    _castleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _castleRotation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0, end: 0.087),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.087, end: -0.087),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: -0.087, end: 0),
            weight: 1,
          ),
        ]).animate(
          CurvedAnimation(parent: _castleController, curve: Curves.easeInOut),
        );

    _castleScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _castleController, curve: Curves.easeInOut),
    );

    // Start animations
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _infoCardController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _infoCardController.dispose();
    _castleController.dispose();
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
              Color(0xFF000000), // black
              Color(0xFF111827), // gray-900
              Color(0xFF581C87), // purple-900
            ],
          ),
        ),
        child: Stack(
          children: [
            // Efectos atmosféricos de fondo
            _buildAtmosphericEffects(),

            // Contenido principal
            SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(),

                  // Contenido scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 448),
                          child: Column(
                            children: [
                              // Galería de imágenes
                              ImageGallery(
                                images: widget.point.imageUrls,
                                onImageSelect: (index) {
                                  print('Imagen seleccionada: $index');
                                },
                              ),

                              const SizedBox(height: 24),

                              // Información del destino
                              _buildInfoCard(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _headerOpacity,
          child: SlideTransition(
            position: _headerOffset,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                border: const Border(
                  bottom: BorderSide(
                    color: Color(0x338B5CF6), // purple-500/20
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Color(0xFFE9D5FF),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Volver a la lista',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFE9D5FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    TimeOfDay.now().format(context),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFD8B4FE),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return AnimatedBuilder(
      animation: _infoCardController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _infoCardOpacity,
          child: SlideTransition(
            position: _infoCardOffset,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF581C87).withOpacity(0.3), // purple-900/30
                    const Color(0xFF4C1D95).withOpacity(0.3), // indigo-900/30
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0x338B5CF6), // purple-500/20
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x80581C87), // purple-900/50
                    blurRadius: 32,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título con ícono
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _castleController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _castleRotation.value,
                            child: Transform.scale(
                              scale: _castleScale.value,
                              child: const Icon(
                                Icons.castle,
                                size: 32,
                                color: Color(0xFFD8B4FE),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.point.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE9D5FF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Descripción
                  Text(
                    widget.point.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFFE9D5FF).withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón de audio
                  AudioButton(
                    audioPath: widget.point.audio,
                    onPlay: () {
                      print('Reproduciendo audio: ${widget.point.audio}');
                    },
                  ),
                  const SizedBox(height: 16),

                  // Indicador de distancia
                  const Center(child: DistanceIndicator(distance: 350)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAtmosphericEffects() {
    return Stack(
      children: List.generate(3, (index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(seconds: (6 + (index * 2))),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Positioned(
              left: (index == 0)
                  ? MediaQuery.of(context).size.width * 0.1
                  : (index == 1)
                  ? MediaQuery.of(context).size.width * 0.7
                  : MediaQuery.of(context).size.width * 0.4,
              top: (index == 0)
                  ? MediaQuery.of(context).size.height * 0.2
                  : (index == 1)
                  ? MediaQuery.of(context).size.height * 0.6
                  : MediaQuery.of(context).size.height * 0.8,
              child: Opacity(
                opacity: Tween<double>(
                  begin: 0.1,
                  end: 0.3,
                ).transform((value + index * 0.3) % 1.0),
                child: Transform.scale(
                  scale: Tween<double>(
                    begin: 1.0,
                    end: 1.2,
                  ).transform((value + index * 0.3) % 1.0),
                  child: Container(
                    width: 200 + (index * 100),
                    height: 200 + (index * 100),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF8B5CF6).withOpacity(0.05),
                    ),
                  ),
                ),
              ),
            );
          },
          onEnd: () {
            if (mounted) setState(() {});
          },
        );
      }),
    );
  }
}
