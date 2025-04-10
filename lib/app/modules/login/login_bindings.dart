import 'package:estacionaqui/app/modules/login/login_controller.dart';
import 'package:get/get.dart';

class LoginBinginds extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
