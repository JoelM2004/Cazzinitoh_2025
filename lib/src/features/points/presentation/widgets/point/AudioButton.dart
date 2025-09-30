import 'package:flutter/material.dart';
import 'dart:async';

class AudioButton extends StatefulWidget {
  final String audioPath; // <-- lo agregás
  final VoidCallback? onPlay;

  const AudioButton({
    Key? key,
    required this.audioPath, // <-- requerido
    this.onPlay,
  }) : super(key: key);

  @override
  State<AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton>
    with TickerProviderStateMixin {
  bool _isPlaying = false;
  int _currentTime = 0;
  final int _duration = 180; // 3 minutos
  Timer? _timer;

  late AnimationController _glowController;
  late AnimationController _headphonesController;
  late AnimationController _progressGlowController;
  late AnimationController _indicatorController;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _headphonesController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _progressGlowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _glowController.dispose();
    _headphonesController.dispose();
    _progressGlowController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  void _handlePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    widget.onPlay?.call();

    if (_isPlaying) {
      _glowController.repeat(reverse: true);
      _headphonesController.repeat(reverse: true);
      _progressGlowController.repeat(reverse: true);
      _indicatorController.repeat(reverse: true);

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_currentTime >= _duration) {
            _isPlaying = false;
            _currentTime = 0;
            _stopAnimations();
            timer.cancel();
          } else {
            _currentTime++;
          }
        });
      });
    } else {
      _stopAnimations();
      _timer?.cancel();
    }
  }

  void _stopAnimations() {
    _glowController.stop();
    _headphonesController.stop();
    _progressGlowController.stop();
    _indicatorController.stop();
  }

  void _handleRewind() {
    setState(() {
      _currentTime = (_currentTime - 15).clamp(0, _duration);
    });
  }

  void _handleForward() {
    setState(() {
      _currentTime = (_currentTime + 15).clamp(0, _duration);
    });
  }

  void _handleProgressTap(TapDownDetails details, double width) {
    final double clickX = details.localPosition.dx;
    final double newTime = (clickX / width) * _duration;
    setState(() {
      _currentTime = newTime.clamp(0, _duration.toDouble()).toInt();
    });
  }

  String _formatTime(int time) {
    final minutes = time ~/ 60;
    final seconds = time % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _duration > 0 ? (_currentTime / _duration) : 0.0;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, fadeValue, child) {
        return Opacity(
          opacity: fadeValue,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - fadeValue)),
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0x99581C87), // purple-900/60
                        Color(0x996D28D9), // purple-800/60
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0x808B5CF6), // purple-500/50
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isPlaying
                            ? Color.lerp(
                                const Color(0x669333EA),
                                const Color(0xB39333EA),
                                _glowController.value,
                              )!
                            : const Color(0x4D9333EA),
                        blurRadius: _isPlaying ? 35 : 15,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Título del audio
                      _buildAudioTitle(),
                      const SizedBox(height: 12),

                      // Controles de reproducción
                      _buildControls(),
                      const SizedBox(height: 12),

                      // Barra de progreso
                      _buildProgressBar(progress),
                      const SizedBox(height: 8),

                      // Tiempo
                      _buildTimeDisplay(),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAudioTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _headphonesController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _isPlaying
                  ? Tween<double>(
                      begin: -0.174,
                      end: 0.174,
                    ).animate(_headphonesController).value
                  : 0,
              child: const Icon(
                Icons.headphones,
                size: 16,
                color: Color(0xFFD8B4FE),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        const Text(
          'Audio Descriptivo del lugar',
          style: TextStyle(fontSize: 14, color: Color(0xFFE9D5FF)),
        ),
        if (_isPlaying) ...[
          const SizedBox(width: 8),
          Row(
            children: List.generate(3, (index) {
              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 3.0, end: 12.0),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Container(
                    width: 4,
                    height: value,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8B4FE),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
                onEnd: () {
                  if (mounted && _isPlaying) {
                    setState(() {});
                  }
                },
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildControlButton(icon: Icons.fast_rewind, onTap: _handleRewind),
        const SizedBox(width: 16),
        _buildPlayPauseButton(),
        const SizedBox(width: 16),
        _buildControlButton(icon: Icons.fast_forward, onTap: _handleForward),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0x4D6D28D9), // purple-800/30
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0x4D8B5CF6), // purple-500/30
          ),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFFD8B4FE)),
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: _handlePlayPause,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0x4DA855F7), // purple-400/30
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x807C3AED),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          size: 24,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return GestureDetector(
      onTapDown: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        _handleProgressTap(details, box.size.width - 32);
      },
      child: Container(
        height: 12,
        decoration: BoxDecoration(
          color: const Color(0xB3581C87), // purple-900/70
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color(0x4D7C3AED), // purple-600/30
          ),
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _progressGlowController,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(0xFFA855F7),
                        const Color(0xFF8B5CF6),
                      ],
                      stops: [0.0, progress],
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: _isPlaying
                        ? [
                            BoxShadow(
                              color: Color.lerp(
                                const Color(0x99A855F7),
                                const Color(0xE6A855F7),
                                _progressGlowController.value,
                              )!,
                              blurRadius: 15,
                            ),
                          ]
                        : null,
                  ),
                );
              },
            ),
            // Indicador de posición
            AnimatedBuilder(
              animation: _indicatorController,
              builder: (context, child) {
                final scale = _isPlaying
                    ? Tween<double>(
                        begin: 1.0,
                        end: 1.3,
                      ).animate(_indicatorController).value
                    : 1.0;

                return Positioned(
                  left:
                      (progress * (MediaQuery.of(context).size.width - 64)) - 8,
                  top: -2,
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9D5FF),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFA855F7),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _isPlaying
                                ? Color.lerp(
                                    const Color(0x80A855F7),
                                    const Color(0xCCA855F7),
                                    _indicatorController.value,
                                  )!
                                : const Color(0x80A855F7),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatTime(_currentTime),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFE9D5FF),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          _formatTime(_duration),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFE9D5FF),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
