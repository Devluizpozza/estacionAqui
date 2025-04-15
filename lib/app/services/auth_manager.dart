import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/app_user_model.dart';
import 'package:estacionaqui/app/modules/user/user_controller.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/routes/app_routes.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthManager extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static AuthManager get instance => Get.find<AuthManager>();
  Rxn<User> firebaseUser = Rxn<User>();
  final AppUserRepository appUserRepository = AppUserRepository();
  final RxBool _isManualLogin = false.obs;

  bool get isManualLogin => _isManualLogin.value;

  set isManualLogin(bool value) {
    _isManualLogin.value = value;
    _isManualLogin.refresh();
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, handleAuthChanged);
    super.onInit();
  }

  bool get isLoggedIn => firebaseUser.value != null;

  String? get userUID => firebaseUser.value?.uid;

  static AuthManager get to => Get.find<AuthManager>();

  Future<void> signOut() async {
    await _auth.signOut();
    Get.toNamed(AppRoutes.home);
  }

  void handleAuthChanged(User? user) async {
    if (isManualLogin) {
      Logger.info("handleAuthChanged → Ignorado, login manual em andamento.");
      return;
    }

    if (user == null) {
      Logger.info("handleAuthChanged → Usuário deslogado.");
      UserController.instance.clear();
      Get.offAllNamed('/login');
    } else {
      Logger.info("handleAuthChanged → Usuário logado. Buscando dados...");
      await UserController.instance.fetch(user.uid);
      if (user.uid.isNotEmpty) {
        Get.offAllNamed('/home');
      }
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential = await _auth.signInWithCredential(
            credential,
          );
          User? user = userCredential.user;

          if (user != null) {
            AppUser remoteUser = await appUserRepository.fetch(user.uid);
            if (remoteUser.name.isEmpty) {
              Get.toNamed(
                AppRoutes.register_user,
                arguments: [
                  {userUID: user.uid, phoneNumber: phoneNumber},
                ],
              );
            } else {
              Get.toNamed(AppRoutes.initial, arguments: userUID);
            }
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            SnackBarHandler.snackBarError("Número de telefone inválido!");
          } else {
            SnackBarHandler.snackBarError(e.code);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          _showCodeInputBottomSheet(verificationId, phoneNumber);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        },
      );
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        SnackBarHandler.snackBarError(
          'Login cancelado! Você não selecionou nenhuma conta.',
        );
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );
        User? user = userCredential.user;
        if (user != null && user.uid.isNotEmpty) {
          AppUser remoteUser = await appUserRepository.fetch(user.uid);
          String? email = user.email;

          if (remoteUser.name.isEmpty) {
            Get.toNamed(
              AppRoutes.register_user,
              arguments: {
                'userUID': user.uid,
                'email': email,
                "phoneNumber": '',
              },
            );
          } else {
            UserController.instance.user = remoteUser;
            Get.toNamed(AppRoutes.initial, arguments: user.uid);
            SnackBarHandler.snackBarSuccessLogin(remoteUser.name);
          }
        }
      }
      SnackBarHandler.snackBarSuccess('Login com Google realizado!');
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> verifyCode(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      SnackBarHandler.snackBarError('Erro, Falha ao verificar código');
    }
  }

  void _showCodeInputBottomSheet(String verificationId, String phoneNumber) {
    final TextEditingController codeController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Digite o código SMS",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: "Código",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _confirmCode(
                  codeController.text.trim(),
                  verificationId,
                  phoneNumber,
                );
              },
              child: Text("Confirmar"),
            ),
          ],
        ),
      ),
      isDismissible: false,
      enableDrag: false,
    );
  }

  Future<void> _confirmCode(
    String smsCode,
    String verificationId,
    String phoneNumber,
  ) async {
    if (smsCode.isEmpty) {
      SnackBarHandler.snackBarError("Por favor, insira o código.");
      return;
    }
    try {
      isManualLogin = true;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;

      if (user != null && user.uid.isNotEmpty) {
        AppUser remoteUser = await appUserRepository.fetch(user.uid);

        if (remoteUser.name.isEmpty) {
          Get.back();
          Get.toNamed(
            AppRoutes.register_user,
            arguments: {'userUID': user.uid, 'phoneNumber': phoneNumber},
          );
        } else {
          UserController.instance.user = remoteUser;
          Get.toNamed(AppRoutes.initial, arguments: user.uid);
          SnackBarHandler.snackBarSuccessLogin(remoteUser.name);
        }
      }
    } catch (e) {
      SnackBarHandler.snackBarError("Erro ao confirmar o código.");
      Logger.info(e.toString());
    }
  }
}
