import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/models/vehicle_model.dart';
import 'package:estacionaqui/app/modules/user/user_controller.dart';
import 'package:estacionaqui/app/repositories/vehicle_repository.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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

  Future<void> createVehicle() async {
    try {
      Vehicle vehicle = Vehicle(
        uid: DB.generateUID(Collections.vehicle),
        plate: "ACD7859",
        userUID: userUID,
        vehicleColor: "#ffffff",
        vehicleType: VehicleType.car,
        carMarkType: CarMarkType.bmw,
        createAt: DateTime.now(),
      );
      bool success = await vehicleRepository.create(userUID, vehicle);
      if (success) {
        await onRefresh();
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
