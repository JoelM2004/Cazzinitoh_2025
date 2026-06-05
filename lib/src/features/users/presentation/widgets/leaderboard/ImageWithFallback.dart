import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:flutter/material.dart';

class ImageWithFallback extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;

  const ImageWithFallback({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 0,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderWidth > 0
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.purpleCardBorder,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.purple300,
              size: 32,
            ),
          ),
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: AppColors.purpleCardBorder,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.purplePrimary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}