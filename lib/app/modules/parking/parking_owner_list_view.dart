import 'package:estacionaqui/app/components/loading_widget.dart';
import 'package:estacionaqui/app/components/scaffold_theme.dart';
import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/modules/parking/parking_owner_list_controller.dart';
import 'package:estacionaqui/app/routes/app_routes.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingOwnerList extends GetView<ParkingOwnerListController> {
  const ParkingOwnerList({super.key});

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
                    'Parking Owner',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "🅿️ Meus Estacionamentos",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Obx(
                            () => Visibility(
                              visible: controller.parkings.isNotEmpty,
                              replacement: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                child: Text(
                                  "Não há estacionamentos cadastrados",
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
                                  itemCount: controller.parkings.length,
                                  itemBuilder: (context, index) {
                                    final Parking parking =
                                        controller.parkings[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: _buildParkingCard(
                                        onLongPress:
                                            () => controller
                                                .parkingOptionOnLongPressed(
                                                  context,
                                                  parking,
                                                ),
                                        title: parking.displayName,
                                        spots: "15/${parking.slots} vagas",
                                        earnings: "R\$ 540,00 hoje",
                                        onTap:
                                            () => Get.toNamed(
                                              AppRoutes.parking_financial,
                                              arguments: {
                                                "parkingName":
                                                    parking.displayName,
                                                "parkingUID": parking.uid,
                                              },
                                            ),
                                      ),
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
                    Get.toNamed(AppRoutes.parking_add);
                  },
                  backgroundColor: AppColors.lightBlue,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
    );
  }

  Widget _buildParkingCard({
    required String title,
    required String spots,
    required String earnings,
    void Function()? onTap,
    void Function()? onLongPress,
  }) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade300,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(
                Icons.local_parking,
                size: 40,
                color: Colors.blueAccent,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(spots, style: const TextStyle(color: Colors.black54)),
                    Text(
                      earnings,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
