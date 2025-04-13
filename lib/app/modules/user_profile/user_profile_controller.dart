import 'dart:io';

import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/app_user_model.dart';
import 'package:estacionaqui/app/modules/user/user_controller.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/services/image_picker.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  final Rx<bool> _isEditing = Rx<bool>(false);
  final Rx<bool> _isLoading = Rx<bool>(false);
  final Rx<AppUser> _user = AppUser.empty().obs;
  final AppUserRepository appUserRepository = AppUserRepository();
  final ImagePickerService imagePickerService = ImagePickerService();
  final nameController = TextEditingController();
  final placaController = TextEditingController();
  final contatoController = TextEditingController();
  final emailController = TextEditingController();
  final Rx<String> _imageUrl = ''.obs;

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

  AppUser get user => _user.value;

  set user(AppUser value) {
    _user.value = value;
    _user.refresh();
  }

  void updateUser(AppUser newUser) {
    user = newUser;
  }

  String get imageUrl => _imageUrl.value;

  set imageUrl(String value) {
    _imageUrl.value = value;
    _imageUrl.refresh();
  }

  @override
  void onInit() async {
    await fetchAppUserData();
    loadUserDataBase();
    super.onInit();
  }

  void loadUserDataBase() {
    nameController.text = user.name;
    contatoController.text = user.contato;
    emailController.text = user.email;
    imageUrl = user.imageUrl;
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
      isLoading = true;
      AppUser appUser = await appUserRepository.fetch(
        UserController.instance.user!.uid,
      );
      if (appUser.uid.isNotEmpty) {
        user = AppUser(
          uid: appUser.uid,
          name: appUser.name,
          contato: appUser.contato,
          email: appUser.email,
          imageUrl: appUser.imageUrl,
        );
        loadUserDataBase();
        isLoading = false;
      }
      isLoading = false;
    } catch (e) {
      Logger.info(e.toString());
      isLoading = false;
    }
  }

  Future<void> updateUserData() async {
    try {
      isLoading = true;
      if (user.uid.isNotEmpty) {
        appUserRepository.updateOnly(user.uid, {
          "name": nameController.text,
          "placa": placaController.text,
          "email": emailController.text,
        });
        isLoading = false;
      }
      isLoading = false;
    } catch (e) {
      Logger.info(e.toString());
      isLoading = false;
    }
  }

  Future<void> handleImageSelection({required bool fromCamera}) async {
    File? image =
        fromCamera
            ? await imagePickerService.pickImageFromCamera()
            : await imagePickerService.pickImageFromGallery();
    if (image != null) {
      final imageUrl = await imagePickerService.uploadUserProfileImage(
        image,
        user.uid,
      );
      if (imageUrl != null) {
        bool success = await appUserRepository.updateOnly(user.uid, {
          "imageUrl": imageUrl,
        });
        if (success) {
          SnackBarHandler.snackBarSuccess(
            'Imagem de perfil atualizada com sucesso.',
          );
        }
      }
    }
  }

  void selectImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tirar foto'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await handleImageSelection(fromCamera: true);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Escolher da galeria'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await handleImageSelection(fromCamera: false);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
