import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/app_user_model.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/routes/app_routes.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterUserController extends GetxController {
  final AppUserRepository appUserRepository = AppUserRepository();
  late String userUID;
  late String phoneNumber;
  final nameController = TextEditingController();
  final placaController = TextEditingController();
  final emailController = TextEditingController();
  final RxBool _isEditing = false.obs;
  final RxBool _isLoading = false.obs;

  bool get isEditing => _isEditing.value;

  set isEditing(bool value) {
    _isEditing.value = value;
    _isEditing.refresh();
  }

  bool get isLoading => _isLoading.value;

  set isLoading(bool value) {
    _isLoading.value = value;
    _isLoading.refresh();
  }

  @override
  void onInit() {
    final Map<String, dynamic> data = Get.arguments;
    if (data.isNotEmpty) {
      userUID = data['userUID'];
      phoneNumber = data['phoneNumber'] ?? '';
    }
    super.onInit();
  }

  Future<void> createUser() async {
    try {
      AppUser userToSave = AppUser(
        uid: userUID,
        name: nameController.text,
        contato: phoneNumber,
        email: emailController.text,
      );
      bool success = await appUserRepository.create(userToSave);
      if (success) {
        SnackBarHandler.snackBarSuccess('Usuário criado com sucesso!');
        Get.toNamed(AppRoutes.verify);
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  // @override
  // void onClose() {
  //   super.onClose();
  //   nameController.dispose();
  //   placaController.dispose();
  //   contatoController.dispose();
  //   emailController.dispose();
  // }
}
