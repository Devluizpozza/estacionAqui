import 'package:estacionaqui/app/modules/home/home_view.dart';
import 'package:estacionaqui/app/modules/login/login_view.dart';
import 'package:estacionaqui/app/services/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthStateWidget extends StatelessWidget {
  const AuthStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final auth = AuthManager.to;
      if (auth.isLoggedIn) {
        return const HomeView();
      } else {
        return const LoginView();
      }
    });
  }
}
