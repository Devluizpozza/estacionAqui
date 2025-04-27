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
import 'package:estacionaqui/app/services/geo_location_service.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingAddController extends GetxController {
  final displayNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final ParkingRepository parkingRepository = ParkingRepository();
  final AppUserRepository appUserRepository = AppUserRepository();
  final Rx<int> _slot = Rx<int>(10);
  final Rx<List<String>> _comforts = Rx<List<String>>([]);

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
}
