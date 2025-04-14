import 'package:estacionaqui/app/models/app_user_model.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/services/auth_manager.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final Rx<AppUser?> _user = Rx<AppUser?>(null);
  final AppUserRepository appUserRepository = AppUserRepository();

  static UserController get instance => Get.find<UserController>();

  AppUser? get user => _user.value;

  set user(AppUser? value) {
    _user.value = value;
    _user.refresh();
  }

  Future<AppUser?> fetch(String uid) async {
    try {
      AppUserRepository appUserRepository = AppUserRepository();
      AppUser? remoteUser = await appUserRepository.fetch(uid);

      if (remoteUser.name.isEmpty) {
        Logger.info("Usuário não encontrado ou sem dados. Forçando logout.");
        await AuthManager.instance.signOut();
        return null;
      }

      user = remoteUser;
      return remoteUser;
    } catch (e) {
      Logger.info(e);
      return Future.error(e.toString());
    }
  }

  void clear() {
    user = null;
  }
}
