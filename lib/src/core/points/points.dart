import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PointsSrc {
  static List<Point> points = [
    Point(
      id: 1,
      name: 'Barrio Parque (Plaza Malvinas Argentinas)',
      description:
          'A comienzos de los años 50 la compañía estatal de petróleo levantó el Barrio Parque para alojar a sus trabajadores, muchos migrantes del noroeste que llegaron con sus familias. Conocido antes como “Barrio viejo”, fue el primer conjunto habitacional de la empresa en la localidad, planificado con servicios completos.',
      audio: 'assets/audios/plaza_malvinas.mp3',
      imageUrls: [
        "https://ca-times.brightspotcdn.com/dims4/default/2138560/2147483647/strip/true/crop/3402x2300+0+0/resize/1200x811!/quality/75/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F68%2F57%2F8b8001bd479d899193713a8c62b2%2Fmonaco-f1-gp-auto-racing-37308.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSqLYsB749o0tbexjkXbtzngfmYpoyz4ZMfg&s",
        "https://cdn-1.motorsport.com/images/amp/Y99DKOGY/s1000/max-verstappen-red-bull-racing-2.jpg",
        "https://www.clarin.com/2021/12/12/8T5AwFm3__360x240__1.jpg", //La idea sería que en un futuro cercano, estas imágenes sean reemplazadas por fotos reales de los puntos turísticos, y que además las descarguemos y guardemos DENTOR DE UNA URL EN EL PROYECTO.
      ],
      address: 'Z9011 Caleta Olivia, Santa Cruz',
      coords: LatLng(-46.433902, -67.525018),
    ),
    Point(
      id: 2,
      name: 'Capilla Cristo Obrero',
      description:
          'La capilla Cristo Obrero, primera iglesia de la ciudad, fue inaugurada el 11 de julio de 1963. En su interior hay imágenes de varios patronos riojanos y un Vía Crucis de mármol que se representa cada Viernes Santo. Fue declarada Patrimonio Cultural en 2004 y allí funciona la Legión de María que visita enfermos y organiza el rezo del Rosario.',
      audio: 'assets/audios/capilla_cristo.mp3',
      imageUrls: [
        "https://ca-times.brightspotcdn.com/dims4/default/2138560/2147483647/strip/true/crop/3402x2300+0+0/resize/1200x811!/quality/75/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F68%2F57%2F8b8001bd479d899193713a8c62b2%2Fmonaco-f1-gp-auto-racing-37308.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSqLYsB749o0tbexjkXbtzngfmYpoyz4ZMfg&s",
        "https://cdn-1.motorsport.com/images/amp/Y99DKOGY/s1000/max-verstappen-red-bull-racing-2.jpg",
        "https://www.clarin.com/2021/12/12/8T5AwFm3__360x240__1.jpg",
      ],
      address: 'C. Colombia 1069-1099, Z9011 Caleta Olivia, Santa Cruz',
      coords: LatLng(-46.438379, -67.531012),
    ),
    Point(
      id: 3,
      name: 'Escuela N° 14 “20 de noviembre” ',
      description:
          'La primera escuela permanente de Caleta Olivia, se fundó el 20 de noviembre de 1922 en un terreno de la calle Hipólito Irigoyen (hoy sede de la Empresa Servicios Públicos S.E.).',
      audio: 'assets/audios/escuela_catorce.mp3',
      imageUrls: [
        "https://ca-times.brightspotcdn.com/dims4/default/2138560/2147483647/strip/true/crop/3402x2300+0+0/resize/1200x811!/quality/75/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F68%2F57%2F8b8001bd479d899193713a8c62b2%2Fmonaco-f1-gp-auto-racing-37308.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSqLYsB749o0tbexjkXbtzngfmYpoyz4ZMfg&s",
        "https://cdn-1.motorsport.com/images/amp/Y99DKOGY/s1000/max-verstappen-red-bull-racing-2.jpg",
        "https://www.clarin.com/2021/12/12/8T5AwFm3__360x240__1.jpg",
      ],
      address: 'Juan Álvarez 263, Z9011 Caleta Olivia, Santa Cruz',
      coords: LatLng(-46.4357855, -67.5194373),
    ),
    Point(
      id: 4,
      name: 'Monumento al Obrero Petrolero',
      description:
          'La pieza personifica al petróleo en la figura de un trabajador que abre una válvula —torso descubierto para resaltar la anatomía— homenajea a quienes llegaron de lugares lejanos en busca de progreso. Se ensambló en un galpón del Club Ingeniero Knudsen; entre el 13 y 15 de diciembre de 1969 se colocaron primero los pantalones y botines, y luego el torso, momento que estalló en vítores con un contundente “¡Viva el Gorosito!”',
      audio: 'assets/audios/monumento_gorosito.mp3',
      imageUrls: [
        "https://ca-times.brightspotcdn.com/dims4/default/2138560/2147483647/strip/true/crop/3402x2300+0+0/resize/1200x811!/quality/75/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F68%2F57%2F8b8001bd479d899193713a8c62b2%2Fmonaco-f1-gp-auto-racing-37308.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSqLYsB749o0tbexjkXbtzngfmYpoyz4ZMfg&s",
        "https://cdn-1.motorsport.com/images/amp/Y99DKOGY/s1000/max-verstappen-red-bull-racing-2.jpg",
      ],
      address: 'Av. San Martín 1, Z9011 Caleta Olivia, Santa Cruz',
      coords: LatLng(-46.441976, -67.517597),
    ),
    Point(
      id: 5,
      name: 'Hospital Meprisa',
      description:
          'El hospital, construido por YPF e inaugurado el 12 de julio de 1963 bajo la dirección del Dr. Manuel A. Sueiro, se creó para brindar atención principalmente al personal petrolero del norte de la región. Clave durante la Guerra de Malvinas por su respuesta al accidente del helicóptero en la costa, fue privatizado el 1 de agosto de 1992 como MEPRISA (mayormente formado por ex empleados) y hoy es un referente sanitario.',
      audio: 'assets/audios/hospital_meprisa.mp3',
      imageUrls: [
        "https://ca-times.brightspotcdn.com/dims4/default/2138560/2147483647/strip/true/crop/3402x2300+0+0/resize/1200x811!/quality/75/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F68%2F57%2F8b8001bd479d899193713a8c62b2%2Fmonaco-f1-gp-auto-racing-37308.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSqLYsB749o0tbexjkXbtzngfmYpoyz4ZMfg&s",
        "https://cdn-1.motorsport.com/images/amp/Y99DKOGY/s1000/max-verstappen-red-bull-racing-2.jpg",
      ],
      address: 'Av. Güemes 1382, Z9011 Caleta Olivia, Santa Cruz',
      coords: LatLng(-46.439077, -67.530888),
    ),

    // Agrega más puntos según sea necesario
  ];
}
