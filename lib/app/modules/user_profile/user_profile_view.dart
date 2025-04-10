import 'package:estacionaqui/app/models/user_model.dart';
import 'package:estacionaqui/app/modules/user_profile/user_profile_controller.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileView extends GetView<UserProfileController> {
  const UserProfileView({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Perfil"),
        actions: [
          Obx(
            () =>
                controller.isEditing
                    ? IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        controller.updateUser(
                          AppUser(
                            uid: '',
                            name: controller.nameController.text,
                            placa: controller.placaController.text,
                            contato: controller.contatoController.text,
                            email: controller.emailController.text,
                          ),
                        );
                        controller.isEditing = false;
                      },
                    )
                    : IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        // final user = controller.user;
                        // controller.nameController.text = user.name;
                        // controller.placaController.text = user.placa;
                        // controller.contatoController.text = user.contato;
                        // controller.emailController.text = user.email;
                        // controller.isEditing = true;
                        await controller.createUser();
                      },
                    ),
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.user;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.lightBlue,
                child: Icon(Icons.person, size: 50, color: Colors.black),
              ),
              const SizedBox(height: 20),
              _buildField(
                "Name",
                user.name,
                controller.nameController,
                controller.isEditing,
              ),
              _buildField(
                "Placa",
                user.placa,
                controller.placaController,
                controller.isEditing,
              ),
              _buildField(
                "Contato",
                user.contato,
                controller.contatoController,
                controller.isEditing,
              ),
              _buildField(
                "Email",
                user.email,
                controller.emailController,
                controller.isEditing,
              ),
            ],
          ),
        );
      }),
    );
  }
}

Widget _buildField(
  String label,
  String value,
  TextEditingController controller,
  bool editing,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextField(
      controller: controller..text = value,
      enabled: editing,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !editing,
        fillColor: editing ? Colors.white : Colors.grey.shade100,
      ),
    ),
  );
}
