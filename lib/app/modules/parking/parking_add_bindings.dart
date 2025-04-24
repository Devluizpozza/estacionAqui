import 'package:estacionaqui/app/modules/parking/parking_add_controller.dart';
import 'package:get/get.dart';

class ParkingAddBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingAddController>(() => ParkingAddController());
  }
}
