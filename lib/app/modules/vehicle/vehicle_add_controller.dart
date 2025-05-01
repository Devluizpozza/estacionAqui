import 'package:estacionaqui/app/consts/enums.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class VehicleAddController extends GetxController {
  final Rx<VehicleType> _vehicleTypeSelected = Rx<VehicleType>(
    VehicleType.none,
  );

  List<VehicleType> get vehicleTypeToOption =>
      VehicleType.values
          .where((VehicleType vehicleType) => vehicleType != VehicleType.none)
          .toList();

  VehicleType get vehicleTypeSelected => _vehicleTypeSelected.value;

  set vehicleTypeSelected(VehicleType value) {
    _vehicleTypeSelected.value = value;
    _vehicleTypeSelected.refresh();
  }
}
