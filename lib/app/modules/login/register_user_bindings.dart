import 'package:estacionaqui/app/modules/login/register_user_controller.dart';
import 'package:get/get.dart';

class RegisterUserBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterUserController>(() => RegisterUserController());
  }
}
