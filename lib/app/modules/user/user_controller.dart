import 'package:estacionaqui/app/models/app_user_model.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/services/auth_manager.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UserController extends GetxController {
  late Rx<AppUser>? _user;

  AppUser get user => _user!.value;

  set user(AppUser value) {
    try {
      _user = Rx<AppUser>(value);
      _user!.refresh();
    } catch (e) {
      Logger.info(e);
    }
  }

  Future<AppUser?> fetch() async {
    try {
      String uid = AuthManager.instance.currentUser!.uid;
      AppUserRepository appUserRepository = AppUserRepository();
      AppUser? remoteUser = await appUserRepository.fetch(uid);

      user = remoteUser;
      _user!.refresh();
      return remoteUser;
    } catch (e) {
      Logger.info(e);
      return Future.error(e.toString());
    }
  }
}
