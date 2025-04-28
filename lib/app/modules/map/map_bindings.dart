import 'package:estacionaqui/app/modules/map/map_controller.dart';
import 'package:get/get.dart';

class MapBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapToViewController>(() => MapToViewController());
  }
}
