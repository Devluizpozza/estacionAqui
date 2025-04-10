import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsController extends GetxController {
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();
  late GoogleMapController mapController;
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set isLoading(bool value) {
    _isLoading.value = value;
    _isLoading.refresh();
  }

  final Set<Marker> markers = {
    Marker(
      markerId: const MarkerId("estacionamento1"),
      position: const LatLng(-22.9711, -43.1822),
      infoWindow: const InfoWindow(title: "Estacionamento Ipanema"),
    ),
  };

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

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }
}
