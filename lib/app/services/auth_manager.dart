import 'package:estacionaqui/app/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthManager extends GetxController {
  static AuthManager get instance => Get.find<AuthManager>();

  @override
  void onReady() {
    try {
      listenIdTokenChanges();
    } catch (e) {
      Logger.info(e);
    }
    super.onReady();
  }

  void listenIdTokenChanges() async {
    FirebaseAuth.instance.idTokenChanges().listen((user) async {
      FirebaseAuth.instance.currentUser != null && user != null;
    });
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;

  bool get shouldSignUp =>
      (currentUser!.displayName != null &&
          currentUser!.displayName!.isNotEmpty) ||
      (currentUser!.phoneNumber != null &&
          currentUser!.phoneNumber!.isNotEmpty);

  // Future<bool> signInWithGooglePlayGames() async {
  //   try {
  //     final bool authenticated = await signInWithFirebase();
  //     await Future(() => FirebaseAuth.instance.authStateChanges());
  //     return authenticated;
  //   } catch (e) {
  //     Logger.info(e);
  //     return false;
  //   }
  // }

  // Future<bool> signInWithFirebase({dynamic arguments}) async {
  //   try {
  //     final bool authenticated = await AppMethodChannel.firebasePlatform
  //         .invokeMethod(AppMethodChannel.firebaseSignIn, arguments);
  //     return authenticated;
  //   } catch (e) {
  //     Logger.info(e);
  //     return false;
  //   }
  // }

  // Future<bool> signInWithFirebaseByPlatform() async {
  //   try {
  //     if (Platform.isAndroid) {
  //       return signInWithGooglePlayGames();
  //     }
  //     return signInWithFirebase();
  //   } catch (e) {
  //     Logger.info(e);
  //     return false;
  //   }
  // }

  // Future<void> signIn({
  //   required Future<void> Function(User?) onComplete,
  //   required void Function() onError,
  // }) async {
  //   try {
  //     FirebaseAuth.instance.authStateChanges().listen((User? user) async {
  //       bool authenticated = false;

  //       if (!Consts.is_development) {
  //         bool isSignedIn = await GameAuth.isSignedIn;

  //         if (!isSignedIn ||
  //             currentUser == null ||
  //             DateTime.now()
  //                     .difference(currentUser!.metadata.lastSignInTime!)
  //                     .inHours >=
  //                 6) {
  //           if (!isSignedIn) {
  //             playJoinSound();
  //             authenticated = await signInWithPlatformGames();
  //           } else {
  //             authenticated = await signInWithFirebaseByPlatform();
  //           }
  //           if (authenticated) {
  //             await onComplete(user);
  //           } else {
  //             onComplete(null);
  //           }
  //         } else {
  //           onComplete(currentUser);
  //         }
  //       } else {
  //         if (user == null) {
  //           await showDevSignIn(onComplete: onComplete, onError: onError);
  //         } else {
  //           onComplete(user);
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     // playErrorSound();
  //     onError();
  //     Logger.info(e);
  //   }
  // }
}
