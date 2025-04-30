import 'package:estacionaqui/app/modules/vehicle/vehicle_list_controller.dart';
import 'package:get/get.dart';

class VehicleListBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleListController>(() => VehicleListController());
  }
}
