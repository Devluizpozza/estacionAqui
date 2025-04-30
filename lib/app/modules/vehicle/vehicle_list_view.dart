import 'package:estacionaqui/app/components/loading_widget.dart';
import 'package:estacionaqui/app/components/scaffold_theme.dart';
import 'package:estacionaqui/app/components/vehicle_card.dart';
import 'package:estacionaqui/app/models/vehicle_model.dart';
import 'package:estacionaqui/app/modules/vehicle/vehicle_list_controller.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleListView extends GetView<VehicleListController> {
  const VehicleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.isLoading
              ? LoadingWidget()
              : ScaffoldTheme(
                onRefresh: controller.onRefresh,
                appBar: AppBar(
                  title: const Text(
                    'Meus veículos',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: true,
                  iconTheme: const IconThemeData(color: Colors.black),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Meus veículos",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Obx(
                            () => Visibility(
                              visible: controller.vehicles.isNotEmpty,
                              replacement: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                child: Text(
                                  "Não há veículos cadastrados",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                              child: RefreshIndicator(
                                onRefresh: controller.onRefresh,
                                child: ListView.builder(
                                  itemCount: controller.vehicles.length,
                                  itemBuilder: (context, index) {
                                    final Vehicle vehicle =
                                        controller.vehicles[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: VehicleCard(vehicle: vehicle),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    controller.createVehicle();
                  },
                  backgroundColor: AppColors.lightBlue,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
    );
  }
}
