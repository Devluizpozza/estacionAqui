import 'package:estacionaqui/app/components/drop_down_enum.dart';
import 'package:estacionaqui/app/components/input_comfort.dart';
import 'package:estacionaqui/app/components/input_text.dart';
import 'package:estacionaqui/app/components/slot_selector.dart';
import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/modules/vehicle/vehicle_add_controller.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleAddView extends GetView<VehicleAddController> {
  VehicleAddView({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar veículo")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              InputText(label: "placa", controller: _controller),
              InputText(label: "placa", controller: _controller),
              InputText(label: "DisplayName", controller: _controller),
              DropDownEnum<VehicleType>(
                label: 'Tipo do veículo',
                selectedValue: controller.vehicleTypeSelected,
                onChanged: (value) => controller.vehicleTypeSelected = value!,
                values: controller.vehicleTypeToOption,
                display: (v) => v.name,
              ),

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
                  SlotSelector(initialValue: 10, onChanged: (int value) {}),
                ],
              ),
              const SizedBox(height: 10),

              InputComfort(comforts: [], onChanged: (newComfort) {}),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: FloatingActionButton(
          backgroundColor: AppColors.lightBlue,
          onPressed: () => {},
          child: const Icon(Icons.arrow_forward, color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class TipoVeiculo {}
