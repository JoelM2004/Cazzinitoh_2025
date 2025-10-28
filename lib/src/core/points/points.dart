// ARCHIVO: data/points_src.dart
// Este es el archivo que contiene tus puntos turísticos

import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:latlong2/latlong.dart';

class PointsSrc {
  static List<Point> points = [
    Point(
      id: 1,
      name: 'Barrio Parque (Plaza Malvinas Argentinas)',
      description:
          'A comienzos de los años 50 la compañía estatal de petróleo levantó el Barrio Parque para alojar a sus trabajadores, muchos migrantes del noroeste que llegaron con sus familias. Conocido antes como "Barrio viejo", fue el primer conjunto habitacional de la empresa en la localidad, planificado con servicios completos.',
      audio: 'assets/audios/plaza_malvinas.mp3',
      imageUrls: [
        "assets/images/points/plaza_1.png",
        "assets/images/points/plaza_2.png",
        "assets/images/points/plaza_3.png",
      ],
      address: 'Z9011 Caleta Olivia, Santa Cruz',
      coords: const LatLng(-46.433902, -67.525018),
    ),
    Point(
      id: 2,
      name: 'Capilla Cristo Obrero',
      description:
          'La capilla Cristo Obrero, primera iglesia de la ciudad, fue inaugurada el 11 de julio de 1963. En su interior hay imágenes de varios patronos riojanos y un Vía Crucis de mármol que se representa cada Viernes Santo. Fue declarada Patrimonio Cultural en 2004 y allí funciona la Legión de María que visita enfermos y organiza el rezo del Rosario.',
      audio: 'assets/audios/capilla_cristo.mp3',
      imageUrls: [
        "assets/images/points/capilla_1.png",
        "assets/images/points/capilla_2.png",
        "assets/images/points/capilla_3.png",
        "assets/images/points/capilla_4.png",
        "assets/images/points/capilla_5.png",
        "assets/images/points/capilla_6.png",
      ],
      address: 'C. Colombia 1069-1099, Z9011 Caleta Olivia, Santa Cruz',
      coords: const LatLng(-46.438379, -67.531012),
    ),
    Point(
      id: 3,
      name: 'Escuela N° 14 "20 de noviembre" ',
      description:
          'La primera escuela permanente de Caleta Olivia, se fundó el 22 de septiembre de 1922 en un terreno de la calle Hipólito Irigoyen (hoy sede de la Empresa Servicios Públicos S.E.).',
      audio: 'assets/audios/escuela_catorce.mp3',
      imageUrls: [
        "assets/images/points/escuela_1.png",
        "assets/images/points/escuela_2.png",
        "assets/images/points/escuela_3.png",
        "assets/images/points/escuela_4.png",
        "assets/images/points/escuela_5.jpg",
      ],
      address: 'Juan Álvarez 263, Z9011 Caleta Olivia, Santa Cruz',
      coords: const LatLng(-46.4357855, -67.5194373),
    ),
    Point(
      id: 4,
      name: 'Monumento al Obrero Petrolero',
      description:
          'La pieza personifica al petróleo en la figura de un trabajador que abre una válvula —torso descubierto para resaltar la anatomía— homenajea a quienes llegaron de lugares lejanos en busca de progreso. Se ensambló en un galpón del Club Ingeniero Knudsen; entre el 13 y 15 de diciembre de 1969 se colocaron primero los pantalones y botines, y luego el torso, momento que estalló en vítores con un contundente "¡Viva el Gorosito!"',
      audio: 'assets/audios/monumento_gorosito.mp3',
      imageUrls: [
        "assets/images/points/monumento_gorosito_1.png",
        "assets/images/points/monumento_gorosito_2.png",
        "assets/images/points/monumento_gorosito_3.jpg",
        "assets/images/points/monumento_gorosito_4.jpg",
        "assets/images/points/monumento_gorosito_5.jpg",
        "assets/images/points/monumento_gorosito_6.jpg",
      ],
      address: 'Av. San Martín 1, Z9011 Caleta Olivia, Santa Cruz',
      coords: const LatLng(-46.441976, -67.517597),
    ),
    Point(
      id: 5,
      name: 'Hospital Meprisa',
      description:
          'El hospital, construido por YPF e inaugurado el 12 de julio de 1963 bajo la dirección del Dr. Manuel A. Sueiro, se creó para brindar atención principalmente al personal petrolero del norte de la región. Clave durante la Guerra de Malvinas por su respuesta al accidente del helicóptero en la costa, fue privatizado el 1 de agosto de 1992 como MEPRISA (mayormente formado por ex empleados) y hoy es un referente sanitario.',
      audio: 'assets/audios/hospital_meprisa.mp3',
      imageUrls: [
        "assets/images/points/meprisa_1.png",
        "assets/images/points/meprisa_2.png",
        "assets/images/points/meprisa_3.png",
        "assets/images/points/meprisa_4.png",
        "assets/images/points/meprisa_5.png",
        "assets/images/points/meprisa_6.png",
      ],
      address: 'Av. Güemes 1382, Z9011 Caleta Olivia, Santa Cruz',
      coords: const LatLng(-46.439077, -67.530888),
    ),
    Point(
      id: 6,
      name: 'Barrio 26 de Junio',
      description:
          'Inaugurado por YPF en 1962, el Barrio 26 de Junio —conocido popularmente como "Barrio nuevo"— tomó su nombre del 26 de junio de 1944 (hallazgo de petróleo en el pozo O-12, Cañadón Seco) y se diseñó para alojar a obreros y sus familias.',
      audio: 'assets/audios/barrio_26.mp3',
      imageUrls: [
        "assets/images/points/barrio_nuevo_1.png",
        "assets/images/points/barrio_nuevo_2.png",
        "assets/images/points/barrio_nuevo_3.png",
      ],
      address: 'Humberto Beghin 1140, Z9011 Caleta Olivia, Santa Cruz',
      coords: const LatLng(-46.439421, -67.527109),
    ),
    Point(
      id: 7,
      name: 'Almacén de Juan Álvarez',
      description:
          'En los años 30–40 el pueblo tenía apenas dos despensas; en la de los Álvarez imperaba el orden: cada cliente cargaba sus compras en una libreta y pagaba a fin de mes, con hileras de latas, la balanza sobre el mostrador y una barrica de vino a granel. Junto al mostrador una vitrina cuidadosamente organizada mostraba cierres, hilos, botones y elásticos para quien los necesitara.',
      audio: 'assets/audios/almacen.mp3',
      imageUrls: [
        "assets/images/points/almacen_1.jpg",
        "assets/images/points/almacen_2.png",
        "assets/images/points/almacen_3.jpg",
        "assets/images/points/almacen_4.jpg",
        "assets/images/points/almacen_5.jpg",
        "assets/images/points/almacen_6.jpg",
      ],
      address: 'Juan Álvarez 466, Z9011 Caleta Olivia, Santa Cruz',
      coords: const LatLng(-46.435435, -67.515941),
    ),
  ];
}
