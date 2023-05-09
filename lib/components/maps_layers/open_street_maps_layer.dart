import 'package:flutter_map/flutter_map.dart';

class OpenStreetMapsLayer extends TileLayer {
  OpenStreetMapsLayer({
    super.key,
    super.maxZoom = 19,
    super.subdomains = const ['a', 'b', 'c'],
    super.fallbackUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    super.urlTemplate = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  });

  factory OpenStreetMapsLayer.topo() => OpenStreetMapsLayer(urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png', fallbackUrl: 'https://tile.opentopomap.org/{z}/{x}/{y}.png');

  factory OpenStreetMapsLayer.cycl() => OpenStreetMapsLayer(urlTemplate: 'https://{s}.tile.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png', maxZoom: 20);

  factory OpenStreetMapsLayer.humanitarian() => OpenStreetMapsLayer(urlTemplate: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', maxZoom: 20);
}
