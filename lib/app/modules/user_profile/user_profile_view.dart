import 'package:estacionaqui/app/components/loading_widget.dart';
import 'package:estacionaqui/app/modules/user_profile/user_profile_controller.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:estacionaqui/app/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileView extends GetView<UserProfileController> {
  const UserProfileView({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.isLoading
              ? LoadingWidget()
              : Scaffold(
                appBar: AppBar(
                  title: const Text("Meu Perfil"),
                  actions: [
                    Obx(
                      () =>
                          controller.isEditing
                              ? IconButton(
                                icon: const Icon(Icons.save),
                                onPressed: () {
                                  controller.updateUserData();
                                  controller.isEditing = false;
                                },
                              )
                              : IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  final user = controller.user;
                                  controller.nameController.text = user.name;
                                  controller
                                      .contatoController
                                      .text = Regex.only_digits(
                                    user.contato.replaceAll(
                                      RegExp(r'^\+55'),
                                      '',
                                    ),
                                  );
                                  controller.emailController.text = user.email;
                                  controller.isEditing = true;
                                  // await controller.createUser();
                                },
                              ),
                    ),
                  ],
                ),
                body: Obx(() {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        controller.isEditing
                            ? Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: AppColors.lightBlue,
                                  backgroundImage:
                                      controller.user.imageUrl.isNotEmpty
                                          ? NetworkImage(
                                            controller.user.imageUrl,
                                          )
                                          : null,
                                  child:
                                      controller.user.imageUrl.isEmpty
                                          ? Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.black,
                                          )
                                          : null,
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: -7,
                                  child: GestureDetector(
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.photo_camera_sharp,
                                        size: 28,
                                        color: Colors.black,
                                      ),
                                    ),
                                    onTap:
                                        () => controller.selectImage(context),
                                  ),
                                ),
                              ],
                            )
                            : CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.lightBlue,
                              backgroundImage:
                                  controller.user.imageUrl.isNotEmpty
                                      ? NetworkImage(controller.user.imageUrl)
                                      : null,
                              child:
                                  controller.user.imageUrl.isEmpty
                                      ? Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.black,
                                      )
                                      : null,
                            ),
                        const SizedBox(height: 20),
                        _buildField(
                          "Name",
                          controller.nameController,
                          controller.isEditing,
                        ),
                        _buildField(
                          "Contato",
                          controller.contatoController,
                          false,
                        ),
                        _buildField(
                          "Email",
                          controller.emailController,
                          controller.isEditing,
                        ),
                      ],
                    ),
                  );
                }),
                floatingActionButton: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: FloatingActionButton(
                    backgroundColor: AppColors.lightBlue,
                    onPressed: () => {},
                    child: const Icon(
                      Icons.settings,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
              ),
    );
  }
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !editing,
        fillColor: editing ? Colors.white : Colors.grey.shade100,
      ),
    ),
  );
}
