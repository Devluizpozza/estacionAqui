import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/geo_location_point_model.dart';
import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/models/place_short_model.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/repositories/parking_repository.dart';
import 'package:estacionaqui/app/services/geo_location_service.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingAddController extends GetxController {
  final displayNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final slotsController = TextEditingController();
  final ParkingRepository parkingRepository = ParkingRepository();
  final AppUserRepository appUserRepository = AppUserRepository();

  void createParking() async {
    Get.lazyPut(() => GeolocationService());
    try {
      final place = PlaceShort(
        placeId: 'Rua das Flores',
        countryCode: '123',
        city: 'Florianópolis',
        fu: 'SC',
        fullAddress: 'Rua das Flores, 123 - Centro, Florianópolis/SC',
        geolocationPoint: GeolocationPoint(0.0, 2.3),
      );
      Parking parkingToSave = Parking(
        uid: DB.generateUID(Collections.parking),
        displayName: displayNameController.text,
        description: descriptionController.text,
        phone: phoneController.text,
        place: place,
        conforts: ['Coberto', 'Seguro', 'Fácil acesso', 'ducha'],
        slots: 10,
        createAt: DateTime.now(),
      );
      bool success = await parkingRepository.create(parkingToSave);
      if (success) {
        SnackBarHandler.snackBarSuccess('Estacionamento criado com sucesso!');
      } else {
        SnackBarHandler.snackBarError('Falha ao criar estacionamento');
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
