import 'package:estacionaqui/app/modules/parking/parking_detail_controller.dart';
import 'package:get/get.dart';

class ParkingDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingDetailController>(() => ParkingDetailController());
  }
}
