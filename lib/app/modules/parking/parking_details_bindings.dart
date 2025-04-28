import 'package:estacionaqui/app/modules/parking/parking_details_controller.dart';
import 'package:get/get.dart';

class ParkingDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingDetailsController>(() => ParkingDetailsController());
  }
}
