import 'package:flutter/material.dart';

enum DistanceUnit { m, km }

class DistanceIndicator extends StatefulWidget {
  final int distance;
  final DistanceUnit unit;

  const DistanceIndicator({
    Key? key,
    required this.distance,
    this.unit = DistanceUnit.m,
  }) : super(key: key);

  @override
  State<DistanceIndicator> createState() => _DistanceIndicatorState();
}

class _DistanceIndicatorState extends State<DistanceIndicator>
    with TickerProviderStateMixin {
  late AnimationController _compassController;
  late AnimationController _mapPinController;
  late Animation<double> _compassRotation;
  late Animation<double> _mapPinScale;
  late Animation<double> _mapPinOpacity;

  @override
  void initState() {
    super.initState();

    // Compass rotation animation
    _compassController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _compassRotation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0, end: 0.262), // 15 degrees
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.262, end: -0.262), // -15 degrees
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: -0.262, end: 0),
            weight: 1,
          ),
        ]).animate(
          CurvedAnimation(parent: _compassController, curve: Curves.easeInOut),
        );

    // MapPin pulse animation
    _mapPinController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _mapPinScale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _mapPinController, curve: Curves.easeInOut),
    );

    _mapPinOpacity = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _mapPinController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _compassController.dispose();
    _mapPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, fadeValue, child) {
        return Opacity(
          opacity: fadeValue,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - fadeValue)),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0x99581C87), // purple-900/60
                      Color(0x994C1D95), // indigo-900/60
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0x4DA855F7), // purple-400/30
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x66581C87), // purple-900/40
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Compass icon
                    AnimatedBuilder(
                      animation: _compassRotation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _compassRotation.value,
                          child: const Icon(
                            Icons.explore,
                            size: 16,
                            color: Color(0xFFD8B4FE),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),

                    // Text
                    Text(
                      'A ${widget.distance}${widget.unit == DistanceUnit.m ? 'm' : 'km'} de tu ubicación',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE9D5FF),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // MapPin icon
                    AnimatedBuilder(
                      animation: _mapPinController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _mapPinOpacity.value,
                          child: Transform.scale(
                            scale: _mapPinScale.value,
                            child: const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Color(0xFFA855F7),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
