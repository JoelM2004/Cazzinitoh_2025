import 'package:flutter/material.dart';

class ImageGallery extends StatefulWidget {
  final List<String> images;
  final Function(int)? onImageSelect;

  const ImageGallery({Key? key, required this.images, this.onImageSelect})
    : super(key: key);

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _handleImageClick(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _fadeController.forward(from: 0);
      widget.onImageSelect?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Imagen principal
        AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeController.value,
              child: Transform.scale(
                scale: 0.95 + (0.05 * _fadeController.value),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0x4D8B5CF6), // purple-500/30
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x80581C87), // purple-900/50
                        blurRadius: 32,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      children: [
                        Image.network(
                          widget.images[_selectedIndex],
                          width: double.infinity,
                          height: 320,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 320,
                              color: const Color(0xFF374151),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 64,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            );
                          },
                        ),
                        // Gradiente overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF7C3AED).withOpacity(0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Ring interior
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0x33A855F7), // purple-400/20
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Galería de miniaturas
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: List.generate(widget.images.length, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < widget.images.length - 1 ? 12 : 0,
                ),
                child: _buildThumbnail(index),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _handleImageClick(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFA855F7) // purple-400
                : const Color(0x4D7C3AED), // purple-600/30
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Color(0x808B5CF6), // purple-500/50
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              Image.network(
                widget.images[index],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: const Color(0xFF374151),
                    child: const Icon(
                      Icons.broken_image,
                      size: 32,
                      color: Color(0xFF6B7280),
                    ),
                  );
                },
              ),
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    color: const Color(0x338B5CF6), // purple-500/20
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
