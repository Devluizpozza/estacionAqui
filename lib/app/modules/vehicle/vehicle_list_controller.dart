import 'package:estacionaqui/app/handlers/bottom_sheet_handler.dart';
import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/vehicle_model.dart';
import 'package:estacionaqui/app/modules/user/user_controller.dart';
import 'package:estacionaqui/app/repositories/vehicle_repository.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleListController extends GetxController {
  final RxBool _isLoading = false.obs;
  final VehicleRepository vehicleRepository = VehicleRepository();
  final Rx<List<Vehicle>> _vehicles = Rx<List<Vehicle>>(<Vehicle>[]);

  bool get isLoading => _isLoading.value;

  String get userUID => UserController.instance.user!.uid;

  set isLoading(bool value) {
    _isLoading.value = value;
    _isLoading.refresh();
  }

  List<Vehicle> get vehicles => _vehicles.value;

  set vehicles(List<Vehicle> value) {
    _vehicles.value = value;
    _vehicles.refresh();
  }

  @override
  void onInit() async {
    isLoading = true;
    await listVehicles();
    isLoading = false;
    super.onInit();
  }

  Future<void> onRefresh() async {
    await listVehicles();
  }

  Future<void> listVehicles() async {
    try {
      vehicles = await vehicleRepository.list(userUID);
      if (vehicles.isNotEmpty) {
        // print(vehicles);
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  void removeVehicleBottomSheet(BuildContext context, String vehicleUID) {
    BottomSheetHandler.showConfirmationBottomSheet(
      context: context,
      title: "",
      confirmColor: Colors.red,
      confirmText: "Remover",
      onCancel: () => Get.back(),
      onConfirm: () => removeVehicle(vehicleUID),
      cancelText: "Cancel",
    );
  }

  Future<void> removeVehicle(String vehicleUID) async {
    try {
      bool success = await vehicleRepository.remove(vehicleUID, userUID);
      if (success) {
        await listVehicles();
        SnackBarHandler.snackBarSuccess("Veículo removido");
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
