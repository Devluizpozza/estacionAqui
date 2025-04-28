import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapController extends GetxController {
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();
  final RxBool _isLoading = false.obs;
  final Rx<List<Marker>> _markers = Rx<List<Marker>>(<Marker>[]);

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

  // final Set<Marker> markers = {
  //   Marker(
  //     markerId: const MarkerId("estacionamento1"),
  //     position: const LatLng(-22.9711, -43.1822),
  //     infoWindow: const InfoWindow(title: "Estacionamento Ipanema"),
  //   ),
  // };

  @override
  void onInit() async {
    isLoading = true;
    Future.delayed(Duration(seconds: 2));
    await detectarLocalizacao();
    super.onInit();
    isLoading = false;
  }

  Future<void> detectarLocalizacao() async {
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
}
