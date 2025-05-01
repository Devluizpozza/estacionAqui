// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapComponent extends StatefulWidget {
  final List<Marker> markers;
  final void Function(LatLng) onLocationSelected;

  const MapComponent({
    super.key,
    required this.markers,
    required this.onLocationSelected,
  });

  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  final MapController _mapController = MapController();
  final String _tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  double _currentZoom = 12.0;

  void _addMarker(LatLng latlng) {
    widget.onLocationSelected(latlng);
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(1.0, 20.0);
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(1.0, 20.0);
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  void _onZoomSliderChanged(double value) {
    setState(() {
      _currentZoom = value;
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 900,
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(-27.711397, -48.497016),
                initialZoom: _currentZoom,
                onTap: (tapPosition, latlng) => _addMarker(latlng),
              ),
              children: [
                TileLayer(
                  urlTemplate: _tileUrl,
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: widget.markers),
              ],
            ),
            Positioned(
              right: 10,
              bottom: 100,
              child: Column(
                children: [
                  // Botão de Zoom +
                  FloatingActionButton(
                    heroTag: 'zoomIn',
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: _zoomIn,
                    child: const Icon(Icons.add, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  // Slider de Zoom
                  Container(
                    height: 150,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    child: RotatedBox(
                      quarterTurns: -1, // Deixa o slider vertical
                      child: Slider(
                        min: 1.0,
                        max: 20.0,
                        divisions: 19,
                        value: _currentZoom,
                        onChanged: _onZoomSliderChanged,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Botão de Zoom -
                  FloatingActionButton(
                    heroTag: 'zoomOut',
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: _zoomOut,
                    child: const Icon(Icons.remove, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
