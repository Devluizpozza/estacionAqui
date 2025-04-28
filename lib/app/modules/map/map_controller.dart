import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/repositories/parking_repository.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapToViewController extends GetxController {
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();
  final RxBool _isLoading = false.obs;
  final Rx<List<Marker>> _markers = Rx<List<Marker>>(<Marker>[]);
  final ParkingRepository parkingRepository = ParkingRepository();

  bool get isLoading => _isLoading.value;

  set isLoading(bool value) {
    _isLoading.value = value;
    _isLoading.refresh();
  }

  List<Marker> get markers => _markers.value;

  set markers(List<Marker> value) {
    _markers.value = value;
    _markers.refresh();
  }

  @override
  void onInit() async {
    isLoading = true;
    Future.delayed(Duration(seconds: 4));
    await detectLocation();
    await setMarker();
    super.onInit();
    isLoading = false;
  }

  Future<void> detectLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return;
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    currentPosition.value = LatLng(position.latitude, position.longitude);
  }

  Future<void> setMarker() async {
    try {
      final List<Parking> remoteParkings = await parkingRepository.list();
      if (remoteParkings.isNotEmpty) {
        for (Parking remotParking in remoteParkings) {
          Marker markerToSave = Marker(
            point: LatLng(
              remotParking.place.geolocationPoint.latitude,
              remotParking.place.geolocationPoint.longitude,
            ),
            width: 250, // adicione largura
            height: 100,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              child: Container(
                width: 250, // tamanho fixo para o card no mapa
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            remotParking.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            remotParking.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "2/${remotParking.slots}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "vagas",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          markers.add(markerToSave);
        }
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
