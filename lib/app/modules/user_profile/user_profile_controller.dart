import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/user_model.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  final Rx<bool> _isEditing = Rx<bool>(false);
  final Rx<AppUser> _user = AppUser.empty().obs;
  final AppUserRepository appUserRepository = AppUserRepository();
  final nameController = TextEditingController();
  final placaController = TextEditingController();
  final contatoController = TextEditingController();
  final emailController = TextEditingController();

  bool get isEditing => _isEditing.value;

  set isEditing(bool value) {
    _isEditing.value = value;
    _isEditing.refresh();
  }

  AppUser get user => _user.value;

  set user(AppUser value) {
    _user.value = value;
    _user.refresh();
  }

  void updateUser(AppUser newUser) {
    user = newUser;
  }

  void loadUserDataBase(AppUser usuario) {
    user = usuario;
    nameController.text = usuario.name;
    placaController.text = usuario.placa;
    contatoController.text = usuario.contato;
    emailController.text = usuario.email;
  }

  @override
  void onClose() {
    nameController.dispose();
    placaController.dispose();
    contatoController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> fetchAppUserData() async {
    try {
      AppUser appUser = await appUserRepository.fetch('aleatorio213123');
      if (appUser.uid.isNotEmpty) {
        user = AppUser(
          uid: appUser.uid,
          name: appUser.name,
          placa: appUser.placa,
          contato: appUser.contato,
          email: appUser.email,
        );
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> createUser() async {
    try {
      AppUser userToSave = AppUser(
        uid: DB.generateUID(Collections.app_user),
        name: 'usuario${DB.generateId()}',
        placa: DB.generateId(),
        contato: DB.generateId(),
        email: '${DB.generateId()}@gmail.com',
      );
      bool success = await appUserRepository.create(userToSave);
      if (success) {
        SnackBarHandler.snackBarSuccess('Usuário criado com sucesso!');
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
