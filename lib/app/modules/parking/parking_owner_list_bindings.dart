import 'package:estacionaqui/app/modules/parking/parking_owner_list_controller.dart';
import 'package:get/get.dart';

class ParkingOwnerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkingOwnerListController>(() => ParkingOwnerListController());
  }
}
