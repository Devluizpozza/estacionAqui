import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/app_user_model.dart';
import 'package:estacionaqui/app/models/geo_location_point_model.dart';
import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/models/place_short_model.dart';
import 'package:estacionaqui/app/modules/user/user_controller.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/repositories/parking_repository.dart';
import 'package:estacionaqui/app/services/address_map_service.dart';
import 'package:estacionaqui/app/services/geo_location_service.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class ParkingAddController extends GetxController {
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final ParkingRepository parkingRepository = ParkingRepository();
  final AppUserRepository appUserRepository = AppUserRepository();
  final Rx<int> _slot = Rx<int>(10);
  final Rx<List<String>> _comforts = Rx<List<String>>([]);
  final Rx<PlaceShort> _place = Rx<PlaceShort>(PlaceShort.empty());
  final Rx<Marker?> _marker = Rx<Marker?>(null);

  int get slot => _slot.value;

  set slot(int value) {
    _slot.value = value;
    _slot.refresh();
  }

  List<String> get comforts => _comforts.value;

  set comforts(List<String> value) {
    _comforts.value = value;
    _comforts.refresh();
  }

  PlaceShort get place => _place.value;

  set place(PlaceShort value) {
    _place.value = value;
    _place.refresh();
  }

  Marker? get marker => _marker.value;

  set marker(Marker? value) {
    _marker.value = value;
    _marker.refresh();
  }

  void createParking() async {
    Get.lazyPut(() => GeolocationService());
    AppUser ownerToSave = await appUserRepository.fetch(
      UserController.instance.user!.uid,
    );
    try {
      if (ownerToSave.uid.isEmpty) {
        SnackBarHandler.snackBarError(
          "erro ao criar estacionamento, usuário não localizado.",
        );
      }

      Parking parkingToSave = Parking(
        uid: DB.generateUID(Collections.parking),
        owner: ownerToSave,
        displayName: displayNameController.text,
        description: descriptionController.text,
        phone: '+55${phoneController.text}',
        place: place,
        conforts: comforts,
        slots: slot,
        carValue: 0,
        motoValue: 0,
        createAt: DateTime.now(),
      );
      bool success = await parkingRepository.create(parkingToSave);
      if (success) {
        Get.back();
        SnackBarHandler.snackBarSuccess('Estacionamento criado com sucesso!');
        comforts = [];
      } else {
        SnackBarHandler.snackBarError('Falha ao criar estacionamento');
        comforts = [];
      }
    } catch (e) {
      Get.back();
      Logger.info(e.toString());
    }
  }

  void getAddresByLatLng(LatLng latlng) async {
    try {
      place = PlaceShort.empty();
      Map<String, dynamic>? dataFromParam =
          await AddressMapService.getAddressFromCoordinates(
            latlng.latitude,
            latlng.longitude,
          );
      if (dataFromParam != null) {
        Get.back();
        populatePlace(dataFromParam, latlng);
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  void populatePlace(Map<String, dynamic> dataFromParam, LatLng latlng) {
    if (dataFromParam.isNotEmpty) {
      place = PlaceShort(
        placeId: dataFromParam['suburb'],
        countryCode: dataFromParam['postcode'],
        city: dataFromParam['city'],
        fu: dataFromParam['state'],
        fullAddress: dataFromParam['fullAddress'],
        geolocationPoint: GeolocationPoint(latlng.latitude, latlng.longitude),
      );
    }
  }
}
