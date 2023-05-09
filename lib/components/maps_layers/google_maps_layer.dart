import 'package:flutter_map/flutter_map.dart';

class GoogleMapsLayer extends TileLayer {
  GoogleMapsLayer({
    super.key,
    super.maxZoom = 19,
    super.subdomains = const ['mt0', 'mt1', 'mt2', 'mt3'],
    super.urlTemplate = 'http://{s}.google.com/vt/x={x}&y={y}&z={z}',
  });

  factory GoogleMapsLayer.streets() => GoogleMapsLayer(urlTemplate: 'http://{s}.google.com/vt/x={x}&y={y}&z={z}&lyrs=m');

  factory GoogleMapsLayer.traffic() => GoogleMapsLayer(urlTemplate: 'http://{s}.google.com/vt/x={x}&y={y}&z={z}&lyrs=m,traffic');

  factory GoogleMapsLayer.terrain() => GoogleMapsLayer(urlTemplate: 'http://{s}.google.com/vt/x={x}&y={y}&z={z}&lyrs=p');

  factory GoogleMapsLayer.hybrid() => GoogleMapsLayer(urlTemplate: 'http://{s}.google.com/vt/x={x}&y={y}&z={z}&lyrs=s,h');

  factory GoogleMapsLayer.satellite() => GoogleMapsLayer(urlTemplate: 'http://{s}.google.com/vt/x={x}&y={y}&z={z}&lyrs=s');
}
