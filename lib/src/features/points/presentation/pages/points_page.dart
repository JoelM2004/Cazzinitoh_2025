import 'package:cazzinitoh_2025/src/core/points/points.dart';
import 'package:cazzinitoh_2025/src/features/points/presentation/pages/point_page.dart';
import 'package:cazzinitoh_2025/src/features/points/presentation/widgets/points/DestinationCard.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:flutter/material.dart';

class DestinationSelectorScreen extends StatefulWidget {
  const DestinationSelectorScreen({Key? key}) : super(key: key);

  @override
  State<DestinationSelectorScreen> createState() =>
      _DestinationSelectorScreenState();
}

class _DestinationSelectorScreenState extends State<DestinationSelectorScreen> {
  final List<Point> points = PointsSrc.points;
  int? _selectedDestinationId;
  bool _isNavigating = false;

  void _handleDestinationSelect(int id) {
    setState(() {
      _selectedDestinationId = id;
    });
  }

  void _handleViewDetails(Point point) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DestinationDetailScreen(point: point),
      ),
    );
  }

  void _handleNavigate() {
    setState(() {
      _isNavigating = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final point = points.firstWhere((p) => p.id == _selectedDestinationId);
        print('Navegando a: ${point.name}');

        setState(() {
          _selectedDestinationId = null; // ✅ vuelve a la lista
          _isNavigating = false;
        });
      }
    });
  }

  void _handleBack() {
    setState(() {
      _selectedDestinationId = null;
      _isNavigating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isNavigating && _selectedDestinationId != null) {
      return _buildNavigatingScreen();
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000000), Color(0xFF030712), Color(0xFF581C87)],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 448),
                    child: _selectedDestinationId != null
                        ? _buildSelectedView()
                        : _buildListView(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xB31F2937),
        border: Border(bottom: BorderSide(color: Color(0xFF7C3AED), width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0x4D7C3AED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.explore,
                size: 24,
                color: Color(0xFFA855F7),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seleccionar Destino',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Elige tu próxima aventura',
                    style: TextStyle(fontSize: 12, color: Color(0xFFD8B4FE)),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Color(0xFFD8B4FE),
                ),
                const SizedBox(width: 4),
                Text(
                  TimeOfDay.now().format(context),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFD8B4FE),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    print('Número de puntos: ${points.length}'); // Debug

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xCC1F2937),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF7C3AED)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0x4D7C3AED),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.map,
                  size: 16,
                  color: Color(0xFFA855F7),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'La secuencia de puntos ha desaparecido. Selecciona tu próximo destino basándote en las pistas descubiertas.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFD8B4FE),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Icon(Icons.explore, size: 20, color: Color(0xFFA855F7)),
            SizedBox(width: 8),
            Text(
              'Destinos Disponibles',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Mostrar mensaje si no hay puntos
        if (points.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF374151)),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.info_outline, size: 48, color: Color(0xFF6B7280)),
                  SizedBox(height: 12),
                  Text(
                    'No hay puntos disponibles',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Verifica que PointsSrc.points tenga datos',
                    style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
          ),

        // Lista de puntos
        if (points.isNotEmpty)
          ...List.generate(points.length, (index) {
            final point = points[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DestinationCard(
                point: point,
                onSelect: _handleDestinationSelect,
                onViewDetails: _handleViewDetails,
              ),
            );
          }),
      ],
    );
  }

  Widget _buildSelectedView() {
    final selectedPoint = points.firstWhere(
      (p) => p.id == _selectedDestinationId,
    );

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _handleBack,
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Volver a la lista'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFD8B4FE),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xCC1F2937),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF7C3AED)),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.map, size: 20, color: Color(0xFFD8B4FE)),
                  SizedBox(width: 8),
                  Text(
                    'Destino Seleccionado',
                    style: TextStyle(fontSize: 14, color: Color(0xFFD8B4FE)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ✅ Solo foto + título
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: selectedPoint.imageUrls.isNotEmpty
                    ? Image.network(
                        selectedPoint.imageUrls.first,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 180,
                        color: const Color(0xFF374151),
                        child: const Icon(
                          Icons.image,
                          color: Color(0xFF9CA3AF),
                          size: 64,
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              Text(
                selectedPoint.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0x66581C87),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.navigation, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Confirmar y Navegar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigatingScreen() {
    final point = points.firstWhere((p) => p.id == _selectedDestinationId);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF030712), Color(0xFF581C87), Color(0xFF000000)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 384),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xCC1F2937),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF7C3AED)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFA855F7),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Navegando hacia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    point.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD8B4FE),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Preparando tu aventura...',
                    style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
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
