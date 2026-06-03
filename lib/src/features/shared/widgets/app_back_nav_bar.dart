import 'package:flutter/material.dart';
import 'package:cazzinitoh_2025/src/app/theme.dart';

/// Navbar minimalista que solo muestra un botón de volver.
///
/// Uso:
///   appBar: AppBackNavBar(),
///
/// O como widget dentro de un Stack/Column:
///   AppBackNavBar(title: 'Perfil'),
class AppBackNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? backgroundColor;
  final VoidCallback? onBack;

  const AppBackNavBar({
    Key? key,
    this.title,
    this.backgroundColor,
    this.onBack,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: _BackButton(onBack: onBack),
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            )
          : null,
      centerTitle: true,
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback? onBack;

  const _BackButton({this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: onBack ?? () => Navigator.maybePop(context),
        child: Container(
          width: 38,
          height: 38,
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.purpleCard.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.purpleBorder.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
