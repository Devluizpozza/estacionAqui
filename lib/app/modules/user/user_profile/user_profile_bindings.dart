import 'package:estacionaqui/app/modules/user/user_profile/user_profile_controller.dart';
import 'package:get/get.dart';

class UserProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProfileController>(() => UserProfileController());
  }
}
