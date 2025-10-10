import 'package:flutter/material.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';

class DestinationCard extends StatelessWidget {
  final Point point;
  final Function(int) onSelect;
  final Function(Point)? onViewDetails;

  const DestinationCard({
    Key? key,
    required this.point,
    required this.onSelect,
    this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF374151), width: 1),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 0),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF374151),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: point.imageUrls.isNotEmpty
                    ? Image.asset(
                        point.imageUrls[0],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF374151),
                            child: const Icon(
                              Icons.broken_image,
                              size: 32,
                              color: Color(0xFF6B7280),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: const Color(0xFF374151),
                        child: const Icon(
                          Icons.image,
                          size: 32,
                          color: Color(0xFF6B7280),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),

            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    point.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Descripción
                  Text(
                    point.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () => onSelect(point.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7C3AED),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Seleccionar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {
                            if (onViewDetails != null) {
                              onViewDetails!(point);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF374151),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Detalles',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
