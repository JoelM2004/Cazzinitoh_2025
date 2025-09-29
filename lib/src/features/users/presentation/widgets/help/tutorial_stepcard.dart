import 'package:flutter/material.dart';
import 'dart:ui';

class TutorialStepCard extends StatefulWidget {
  final int stepNumber;
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;

  const TutorialStepCard({
    Key? key,
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
  }) : super(key: key);

  @override
  State<TutorialStepCard> createState() => _TutorialStepCardState();
}

class _TutorialStepCardState extends State<TutorialStepCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: _isHovering
              ? Colors.black.withOpacity(0.5)
              : Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF374151), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Number
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7C3AED),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.stepNumber.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Icon
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(widget.icon, size: 28, color: widget.iconColor),
                  ),
                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFD1D5DB),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Necesitarás importar dart:ui para BackdropFilter
