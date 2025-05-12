import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/vehicle_model.dart';
import 'package:estacionaqui/app/modules/user/user_controller.dart';
import 'package:estacionaqui/app/repositories/vehicle_repository.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleAddController extends GetxController {
  final Rx<VehicleType> _vehicleTypeSelected = Rx<VehicleType>(
    VehicleType.none,
  );
  final Rx<CarMarkType> _carMarkTypeSelected = Rx<CarMarkType>(
    CarMarkType.none,
  );
  final Rx<MotoMarkType> _motoMarkTypeSelected = Rx<MotoMarkType>(
    MotoMarkType.none,
  );
  final Rx<String> _vehicleColorSelected = Rx<String>("");
  final VehicleRepository vehicleRepository = VehicleRepository();
  final Rx<Vehicle> _vehicle = Rx<Vehicle>(Vehicle.empty());
  final TextEditingController plateController = TextEditingController();

  List<VehicleType> get vehicleTypeToOption => VehicleType.values;
  List<CarMarkType> get carMarkTypeToOption => CarMarkType.values;
  List<MotoMarkType> get motoMarkTypeOption => MotoMarkType.values;

  String get userUID => UserController.instance.user!.uid;

  String get vehicleColorSelected => _vehicleColorSelected.value;

  set vehicleColorSelected(String value) {
    _vehicleColorSelected.value = value;
    _vehicleColorSelected.refresh();
  }

  VehicleType get vehicleTypeSelected => _vehicleTypeSelected.value;

  set vehicleTypeSelected(VehicleType value) {
    _vehicleTypeSelected.value = value;
    _vehicleTypeSelected.refresh();
  }

  MotoMarkType get motoMarkTypeSelected => _motoMarkTypeSelected.value;

  set motoMarkTypeSelected(MotoMarkType value) {
    _motoMarkTypeSelected.value = value;
    _motoMarkTypeSelected.refresh();
  }

  CarMarkType get carMarkTypeSelected => _carMarkTypeSelected.value;

  set carMarkTypeSelected(CarMarkType value) {
    _carMarkTypeSelected.value = value;
    _carMarkTypeSelected.refresh();
  }

  Vehicle get vehicle => _vehicle.value;

  set vehicle(Vehicle value) {
    _vehicle.value = value;
    _vehicle.refresh();
  }

  Future<void> createVehicle() async {
    try {
      Vehicle vehicleToSave = Vehicle(
        uid: DB.generateUID(Collections.vehicle),
        userUID: userUID,
        plate: plateController.text,
        carMarkType: carMarkTypeSelected,
        motoMarkType: motoMarkTypeSelected,
        vehicleType: vehicleTypeSelected,
        vehicleColor: vehicleColorSelected,
        createAt: DateTime.now(),
      );
      bool success = await vehicleRepository.create(userUID, vehicleToSave);
      if (success) {
        Get.back();
        SnackBarHandler.snackBarSuccess("Veículo cadastrado");
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
