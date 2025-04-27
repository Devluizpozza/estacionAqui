import 'package:estacionaqui/app/components/loading_widget.dart';
import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/modules/parking/parking_owner_list_controller.dart';
import 'package:estacionaqui/app/routes/app_routes.dart';
import 'package:estacionaqui/app/services/auth_manager.dart';
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
              : Scaffold(
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(color: AppColors.lightBlue),
                        child: const Text(
                          'Painel do Dono',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      const ListTile(
                        leading: Icon(Icons.add_business),
                        title: Text('Cadastrar Estacionamento'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.bar_chart),
                        title: Text('Relatórios e Finanças'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Configurações da Conta'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Sair'),
                        onTap: () => AuthManager.instance.signOut(),
                      ),
                    ],
                  ),
                ),
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
                body: Padding(
                  padding: const EdgeInsets.all(20),
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
                      Expanded(
                        child: Visibility(
                          visible: controller.parkings.isNotEmpty,
                          replacement: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "Não há estacionamentos cadastrados",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          child: ListView.builder(
                            itemCount: controller.parkings.length,
                            itemBuilder: (context, index) {
                              final Parking parking =
                                  controller.parkings[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildParkingCard(
                                  title: parking.displayName,
                                  spots: "15/${parking.slots} vagas",
                                  earnings: "R\$ 540,00 hoje",
                                  onTap:
                                      () =>
                                          Get.toNamed(AppRoutes.parking_owner),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
  }) {
    return GestureDetector(
      onTap: onTap,
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
