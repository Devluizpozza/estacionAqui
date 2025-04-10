import 'package:estacionaqui/app/modules/map/google_map_controller.dart';
import 'package:get/get.dart';

class GoogleMapsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleMapsController>(() => GoogleMapsController());
  }
}
