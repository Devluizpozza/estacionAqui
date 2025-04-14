import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/services/auth_manager.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:estacionaqui/app/utils/regex.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final Rx<String> _phoneNumber = ''.obs;
  final Rx<String> _smsCode = ''.obs;
  final AppUserRepository appUserRepository = AppUserRepository();

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  String get phoneNumber => Regex.only_digits(_phoneNumber.value);

  set phoneNumber(String value) {
    _phoneNumber.value = value;
    _phoneNumber.refresh();
  }

  String get smsCode => _smsCode.value;

  set onSmsCodeChanged(String value) {
    _smsCode.value = value;
    _smsCode.refresh();
  }

  void registerWithPhoneNumber() async {
    AuthManager.instance.verifyPhoneNumber("+55$phoneNumber");
  }

  void signInWithGoogle() {
    try {
      AuthManager.to.signInWithGoogle();
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
