import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PointsSrc {
  static List<Point> points = [
    Point(
      id: 1,
      name: 'Catedral de Córdoba',
      description:
          'La Catedral de Córdoba es una impresionante mezcla de arquitectura islámica y cristiana, reflejando la rica historia de la ciudad.',
      audio: 'assets/audios/catedral_cordoba.mp3',
      imageUrls: [
        "https://ca-times.brightspotcdn.com/dims4/default/2138560/2147483647/strip/true/crop/3402x2300+0+0/resize/1200x811!/quality/75/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F68%2F57%2F8b8001bd479d899193713a8c62b2%2Fmonaco-f1-gp-auto-racing-37308.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSqLYsB749o0tbexjkXbtzngfmYpoyz4ZMfg&s",
        "https://cdn-1.motorsport.com/images/amp/Y99DKOGY/s1000/max-verstappen-red-bull-racing-2.jpg",
        "https://www.clarin.com/2021/12/12/8T5AwFm3__360x240__1.jpg", //La idea sería que en un futuro cercano, estas imágenes sean reemplazadas por fotos reales de los puntos turísticos, y que además las descarguemos y guardemos DENTOR DE UNA URL EN EL PROYECTO.
      ],
      coords: LatLng(-31.4201, -64.1888),
    ),
    Point(
      id: 2,
      name: 'Parque Sarmiento',
      description:
          'El Parque Sarmiento es un extenso espacio verde en Córdoba, ideal para actividades al aire libre y eventos culturales.',
      audio: 'assets/audios/parque_sarmiento.mp3',
      imageUrls: [
        "https://ca-times.brightspotcdn.com/dims4/default/2138560/2147483647/strip/true/crop/3402x2300+0+0/resize/1200x811!/quality/75/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F68%2F57%2F8b8001bd479d899193713a8c62b2%2Fmonaco-f1-gp-auto-racing-37308.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSqLYsB749o0tbexjkXbtzngfmYpoyz4ZMfg&s",
        "https://cdn-1.motorsport.com/images/amp/Y99DKOGY/s1000/max-verstappen-red-bull-racing-2.jpg",
        "https://www.clarin.com/2021/12/12/8T5AwFm3__360x240__1.jpg",
      ],
      coords: LatLng(-31.4135, -64.1811),
    ),

    // Agrega más puntos según sea necesario
  ];
}
