import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PointDetailPage extends StatefulWidget {
  final Point point;
  final int number;

  const PointDetailPage({Key? key, required this.point, required this.number})
      : super(key: key);

  @override
  State<PointDetailPage> createState() => _PointDetailPageState();
}

class _PointDetailPageState extends State<PointDetailPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentImage = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_fadeAnim);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _openInGoogleMaps() async {
    final lat = widget.point.coords.latitude;
    final lng = widget.point.coords.longitude;
    final label = Uri.encodeComponent(widget.point.name);

    // Intenta abrir la app de Google Maps primero
    final appUrl = Uri.parse('google.navigation:q=$lat,$lng&mode=w');
    // Fallback a web
    final webUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=walking&destination_place_name=$label');

    if (await canLaunchUrl(appUrl)) {
      await launchUrl(appUrl);
    } else {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final point = widget.point;
    final images = point.imageUrls;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.purpleBackground,
              AppColors.purple900,
              AppColors.purpleBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    _buildCarousel(images),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge número + nombre
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.purple900.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: AppColors.purpleBorder
                                          .withOpacity(0.4)),
                                ),
                                child: Text(
                                  '#${widget.number}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.purple300,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  point.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.darkForeground,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          _InfoRow(icon: Icons.location_on, text: point.address),
                          const SizedBox(height: 8),
                          _InfoRow(
                            icon: Icons.my_location,
                            text:
                                '${point.coords.latitude.toStringAsFixed(6)}, ${point.coords.longitude.toStringAsFixed(6)}',
                            mono: true,
                          ),

                          const SizedBox(height: 20),

                          // ── Botón Google Maps ────────────────────────────
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _openInGoogleMaps,
                              icon: const Icon(Icons.directions, size: 20),
                              label: const Text(
                                'Cómo llegar',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.purple700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.transparent,
                                AppColors.purpleBorder.withOpacity(0.4),
                                Colors.transparent,
                              ]),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Sobre este lugar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.purple400,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            point.description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFFD1D5DB),
                              height: 1.65,
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: const Border(
          bottom: BorderSide(color: Color(0x338B5CF6), width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, color: AppColors.purple300),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Detalle del Punto',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkForeground,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.purple700.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.purpleBorder.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.place, size: 13, color: AppColors.purple400),
                const SizedBox(width: 4),
                Text(
                  'Sitio #${widget.number}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.purple300,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<String> images) {
    return Stack(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _currentImage = i),
            itemBuilder: (_, i) => Image.asset(
              images[i],
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.purpleCardBorder,
                child: const Icon(Icons.broken_image,
                    size: 64, color: Color(0xFF6B7280)),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0, left: 0, right: 0, height: 60,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.purpleBackground.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0, height: 80,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.purple900.withOpacity(0.8),
                ],
              ),
            ),
          ),
        ),
        if (images.length > 1) ...[
          if (_currentImage > 0)
            _CarouselArrow(
              left: true,
              onTap: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
            ),
          if (_currentImage < images.length - 1)
            _CarouselArrow(
              left: false,
              onTap: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
            ),
        ],
        if (images.length > 1)
          Positioned(
            bottom: 14, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentImage == i ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentImage == i
                        ? AppColors.purple400
                        : Colors.white.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        if (images.length > 1)
          Positioned(
            top: 12, right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentImage + 1}/${images.length}',
                style: const TextStyle(
                    fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool mono;

  const _InfoRow({required this.icon, required this.text, this.mono = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.purple400),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: mono ? 11 : 13,
              color: const Color(0xFF9CA3AF),
              fontFamily: mono ? 'monospace' : null,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _CarouselArrow extends StatelessWidget {
  final bool left;
  final VoidCallback onTap;
  const _CarouselArrow({required this.left, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left ? 12 : null,
      right: left ? null : 12,
      top: 0,
      bottom: 0,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Icon(
              left ? Icons.chevron_left : Icons.chevron_right,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}