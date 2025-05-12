import 'package:estacionaqui/app/components/drop_down_enum.dart';
import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/modules/vehicle/vehicle_add_controller.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleAddView extends GetView<VehicleAddController> {
  VehicleAddView({super.key});

  final List<Color> mainColors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.grey,
    Colors.yellow,
  ];

  final Map<Color, String> colorNames = {
    Colors.black: 'Preto',
    Colors.white: 'Branco',
    Colors.red: 'Vermelho',
    Colors.blue: 'Azul',
    Colors.green: 'Verde',
    Colors.grey: 'Cinza',
    Colors.yellow: 'Amarelo',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo Veículo")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text("Placa", style: labelStyle),
                const SizedBox(height: 5),
                TextField(
                  controller: controller.plateController,
                  decoration: inputDecoration,
                ),
                const SizedBox(height: 20),
                DropDownEnum<VehicleType>(
                  label: 'Tipo do veículo',
                  selectedValue: controller.vehicleTypeSelected,
                  onChanged: (value) => controller.vehicleTypeSelected = value!,
                  values: controller.vehicleTypeToOption,
                  display: (v) => v.name,
                ),

                const SizedBox(height: 20),
                controller.vehicleTypeSelected != VehicleType.motorcycle &&
                        controller.vehicleTypeSelected != VehicleType.none
                    ? DropDownEnum<CarMarkType>(
                      label: 'Marca do Carro',
                      selectedValue: controller.carMarkTypeSelected,
                      onChanged:
                          (value) => controller.carMarkTypeSelected = value!,
                      values: controller.carMarkTypeToOption,
                      display: (v) => v.name,
                      disabled:
                          controller.vehicleTypeSelected == VehicleType.none,
                    )
                    : DropDownEnum<MotoMarkType>(
                      label: 'Marca da Moto',
                      selectedValue: controller.motoMarkTypeSelected,
                      onChanged:
                          (value) => controller.motoMarkTypeSelected = value!,
                      values: controller.motoMarkTypeOption,
                      display: (v) => v.name,
                      disabled:
                          controller.vehicleTypeSelected == VehicleType.none,
                    ),
                Text("Cor do veículo", style: labelStyle),
                const SizedBox(height: 20),

                Obx(() {
                  final selectedColor = controller.vehicleColorSelected;
                  return SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: mainColors.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, index) {
                        final color = mainColors[index];
                        final isSelected = selectedColor == colorNames[color];
                        return GestureDetector(
                          onTap: () {
                            controller.vehicleColorSelected =
                                colorNames[color]!;
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  isSelected
                                      ? Border.all(
                                        color: AppColors.lightBlue,
                                        width: 3,
                                      )
                                      : null,
                            ),
                            child: CircleAvatar(
                              backgroundColor: color,
                              radius: 20,
                              child:
                                  color == Colors.white
                                      ? const Icon(
                                        Icons.check,
                                        color: Colors.black54,
                                        size: 18,
                                      )
                                      : null,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),

                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightBlue,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => controller.createVehicle(),
                    icon: const Icon(Icons.save),
                    label: const Text("Salvar veículo"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle get labelStyle =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  InputDecoration get inputDecoration => InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );
}
