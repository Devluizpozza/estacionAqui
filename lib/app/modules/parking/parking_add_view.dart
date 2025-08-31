import 'package:estacionaqui/app/components/input_box.dart';
import 'package:estacionaqui/app/components/input_comfort.dart';
import 'package:estacionaqui/app/components/input_text.dart';
import 'package:estacionaqui/app/components/map.dart';
import 'package:estacionaqui/app/components/slot_selector.dart';
import 'package:estacionaqui/app/handlers/bottom_sheet_handler.dart';
import 'package:estacionaqui/app/modules/parking/parking_add_controller.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:estacionaqui/app/utils/fomatter.dart';
import 'package:estacionaqui/app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingAddView extends GetView<ParkingAddController> {
  const ParkingAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar estacionamento")),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 23,
          left: 23,
          top: 15,
          bottom: 60,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Text("Localização"),
              ),
              Obx(
                () => InputText(
                  label:
                      controller.place.fullAddress.isEmpty
                          ? "Selecione a localização do seu estacionamento"
                          : controller.place.fullAddress,
                  controller: controller.addressController,
                  showSuffixIcon: true,
                  suffixIcon: Icons.map,
                  onPressedSuffixIcon:
                      () => BottomSheetHandler.showSimpleBottomSheet(
                        initialChildSize: 0.9,
                        context,
                        MapComponent(
                          markers: [],
                          onLocationSelected:
                              (latlng) => controller.getAddresByLatLng(latlng),
                        ),
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Text("Nome do estacionamento"),
              ),
              InputText(
                inputDecoration: inputDecoration,
                label: "DisplayName",
                controller: controller.displayNameController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Text("Descrição"),
              ),
              InputBox(
                label: "Description",
                controller: controller.descriptionController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Text("Contato"),
              ),
              InputText(
                inputDecoration: inputDecoration,
                label: "(00) 00000-0000",
                controller: controller.phoneController,
                validator: Validator.phoneValidator,
                keyboardType: TextInputType.number,
                inputFormatters: [Formatter.phoneMask],
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Text(""),
              ),
              InputComfort(
                comforts: controller.comforts,
                onChanged: (newComfort) {
                  controller.comforts = [...controller.comforts, newComfort];
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
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

  InputDecoration get inputDecoration => InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );
}
