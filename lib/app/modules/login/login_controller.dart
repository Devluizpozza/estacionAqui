import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/app_user_model.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:estacionaqui/app/utils/regex.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final Rx<String> _phoneNumber = ''.obs;
  final Rx<String> _smsCode = ''.obs;
  String? _verificationId;
  final AppUserRepository userRepository = AppUserRepository();

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> sendSms() async {
    if (phoneNumber.isEmpty) {
      SnackBarHandler.snackBarError("Digite um número de telefone válido");
      return;
    }
    try {
      String? phoneNumberToSave = Regex.only_digits(phoneNumber);
      await _auth.verifyPhoneNumber(
        phoneNumber: '+55$phoneNumberToSave',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          SnackBarHandler.snackBarSuccess("Login automático realizado!");
        },
        verificationFailed: (FirebaseAuthException e) {
          SnackBarHandler.snackBarError(e.message ?? "Erro desconhecido");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          SnackBarHandler.snackBarSuccess("Código enviado, Verifique seu SMS");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> verifySmsCode() async {
    if (_verificationId == null || smsCode.isEmpty) {
      SnackBarHandler.snackBarError("Código ou ID de verificação ausente");
      return;
    }
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        AppUser userToSave = AppUser(
          uid: DB.generateUID(Collections.app_user),
          name: 'User ${DB.generateId()}',
          contato: phoneNumber,
          email: '',
          placa: '',
        );
        try {
          bool success = await userRepository.create(userToSave);
          if (success) {
            SnackBarHandler.snackBarSuccess('Usuário criado com sucesso!');
          }
        } catch (e) {
          Logger.info(e.toString());
        }
      }
      SnackBarHandler.snackBarSuccess("Login realizado com sucesso!");
    } catch (e) {
      SnackBarHandler.snackBarError("Falha ao verificar código: $e");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        SnackBarHandler.snackBarError(
          "Login cancelado Você não completou o login com Google.",
        );
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        AppUser userToSave = AppUser(
          uid: DB.generateUID(Collections.app_user),
          name: 'Usuario${DB.generateId()}',
          contato: phoneNumber,
          email: '',
          placa: '',
        );
        try {
          bool success = await userRepository.create(userToSave);
          if (success) {
            SnackBarHandler.snackBarSuccess('Usuário criado com sucesso!');
          }
        } catch (e) {
          Logger.info(e.toString());
        }
      }
      SnackBarHandler.snackBarSuccess(
        "Login bem-sucedido Você entrou com sucesso usando o Google!",
      );
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
