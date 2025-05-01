import 'package:estacionaqui/app/modules/vehicle/vehicle_add_controller.dart';
import 'package:get/get.dart';

class VehicleAddBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleAddController>(() => VehicleAddController());
  }
}
