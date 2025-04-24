import 'package:estacionaqui/app/modules/login/register_user_controller.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterUserView extends GetView<RegisterUserController> {
  const RegisterUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildField(
              "Name",
              controller.nameController,
              !controller.isEditing,
            ),
            _buildField(
              "Email",
              controller.emailController,
              !controller.isEditing,
            ),
            _buildField(
              "(00) 00000-0000",
              controller.contatoController,
              !controller.isEditing,
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: FloatingActionButton(
          backgroundColor: AppColors.lightBlue,
          onPressed: () => controller.createUser(),
          child: const Icon(Icons.arrow_forward, color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    bool editing,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        enabled: editing,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blueGrey[200]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: !editing,
          fillColor: editing ? Colors.white : Colors.grey.shade100,
        ),
      ),
    );
  }
}
