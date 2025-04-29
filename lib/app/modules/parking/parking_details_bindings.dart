import 'package:estacionaqui/app/modules/parking/parking_details_controller.dart';
import 'package:get/get.dart';

class ParkingFinancialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingFinancialController>(() => ParkingFinancialController());
  }
}
