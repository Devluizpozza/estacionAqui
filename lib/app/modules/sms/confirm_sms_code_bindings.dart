import 'package:estacionaqui/app/modules/sms/confirm_sms_code_controller.dart';
import 'package:get/get.dart';

class ConfirmSmsCodeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfirmSmsCodeController>(() => ConfirmSmsCodeController());
  }
}
