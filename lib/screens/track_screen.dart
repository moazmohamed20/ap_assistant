import 'package:ap_assistant/apis/location_api.dart';
import 'package:ap_assistant/components/maps_layers/open_street_maps_layer.dart';
import 'package:ap_assistant/models/location.dart';
import 'package:ap_assistant/models/patient.dart';
import 'package:ap_assistant/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class TrackScreen extends GetView<TrackController> {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _locateFab(),
      body: FlutterMap(
        options: MapOptions(
          maxZoom: 19,
          bounds: LatLngBounds(LatLng(31, 35), LatLng(22, 25)),
          maxBounds: LatLngBounds(LatLng(-90, -180.0), LatLng(90.0, 180.0)),
        ),
        mapController: controller.mapController,
        children: [
          // * GoogleMapsLayer(),
          OpenStreetMapsLayer(),
          CurrentLocationLayer(style: const LocationMarkerStyle(markerDirection: MarkerDirection.heading)),
          GetBuilder<TrackController>(builder: (controller) {
            return MarkerLayer(rotate: true, markers: [if (controller.marker != null) controller.marker!]);
          }),
        ],
      ),
    );
  }

  Widget _locateFab() {
    return FloatingActionButton(
      onPressed: controller.locate,
      backgroundColor: Colors.brown,
      child: const Icon(Icons.person_pin),
    );
  }
}

class TrackController extends GetxController {
  final Patient patient;
  TrackController({required this.patient});

  Marker? marker;
  late MapController mapController;

  @override
  void onInit() {
    mapController = MapController();
    super.onInit();
  }

  @override
  void onReady() {
    locate();
    super.onReady();
  }

  void setMarker(TapPosition? tapPosition, LatLng? point) {
    marker = (point != null)
        ? Marker(
            point: point,
            rotateAlignment: Alignment.bottomCenter,
            anchorPos: AnchorPos.align(AnchorAlign.top),
            builder: (context) => const Icon(Icons.location_pin, color: Colors.red, size: 40),
          )
        : null;
    update();
  }

  void locate() async {
    final Location? location;
    try {
      location = await LocationsApi.getLocationOf(patient.id);
    } catch (e) {
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }
    if (location == null) return;

    var position = LatLng(location.latitude, location.longitude);
    mapController.move(position, 19);
    setMarker(null, position);
  }
}
