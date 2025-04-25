import 'package:estacionaqui/app/components/input_box.dart';
import 'package:estacionaqui/app/components/input_comfort.dart';
import 'package:estacionaqui/app/components/input_text.dart';
import 'package:estacionaqui/app/components/slot_selector.dart';
import 'package:estacionaqui/app/modules/parking/parking_add_controller.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingAddView extends GetView<ParkingAddController> {
  const ParkingAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar estacionamento")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            InputText(
              label: "DisplayName",
              controller: controller.displayNameController,
            ),
            InputBox(
              label: "Description",
              controller: controller.descriptionController,
            ),
            InputText(
              label: "(00) 00000-0000",
              controller: controller.phoneController,
            ),
            // _buildField("Slots", controller.slotsController),
            const SizedBox(height: 5),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  child: Text("Vagas"),
                ),
                SlotSelector(
                  initialValue: 10,
                  onChanged: (int value) {
                    controller.slot = value;
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            InputComfort(
              comforts: controller.comforts,
              onChanged: (newComfort) {
                controller.comforts = [...controller.comforts, newComfort];
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: FloatingActionButton(
          backgroundColor: AppColors.lightBlue,
          onPressed: () => controller.createParking(),
          child: const Icon(Icons.arrow_forward, color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
