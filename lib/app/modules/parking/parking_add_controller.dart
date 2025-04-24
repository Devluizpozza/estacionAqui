import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/repositories/parking_repository.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ParkingAddController extends GetxController {
  final displayNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final slotsController = TextEditingController();

  final ParkingRepository parkingRepository = ParkingRepository();

  void createParking() async {
    try {
      Parking parkingToSave = Parking(
        uid: DB.generateUID(Collections.parking),
        displayName: '',
        description: '',
        phone: '',
        conforts: [],
        slots: 20,
        createAt: DateTime.now(),
      );
      bool success = await parkingRepository.create(parkingToSave);
      if (success) {
        SnackBarHandler.snackBarSuccess('Estacionamento criado com sucesso!');
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
