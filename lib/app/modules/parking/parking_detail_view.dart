// ignore_for_file: deprecated_member_use

import 'package:estacionaqui/app/components/loading_widget.dart';
import 'package:estacionaqui/app/modules/parking/parking_detail_controller.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class ParkingDetailView extends GetView<ParkingDetailController> {
  const ParkingDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mocked values
    final double rating = 4.5;
    final List<String> comforts = [
      'Wi-Fi',
      'Cobertura',
      'Câmeras 24h',
      'Pagamento online',
    ];
    final String location = 'Av. Principal, 1234 - Centro, Cidade Exemplo';

    return Obx(
      () => Visibility(
        visible: !controller.isLoading,
        replacement: LoadingWidget(),
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Estacionamento Central',
                    style: TextStyle(fontSize: 16),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/logo_car.png',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Tooltip(
                    message: '1.234 seguidores',
                    child: IconButton(
                      icon: Icon(Icons.group, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Estacionamento Central',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Obx(
                            () => ElevatedButton(
                              onPressed: () {
                                if (controller.isFollowing) {
                                  controller.showUnfollowOptions();
                                } else {
                                  controller.handleFollow();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                controller.isFollowing ? 'Seguindo' : 'Seguir',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Avaliação
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      // Descrição
                      Text(
                        'Um estacionamento seguro e moderno no centro da cidade. '
                        'Oferecemos vagas cobertas, Wi-Fi gratuito e segurança 24h.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      // Comforts
                      Text(
                        'Confortos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            comforts.map((comfort) {
                              return Chip(
                                label: Text(comfort),
                                backgroundColor: Colors.blue.shade50,
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 24),
                      // Localização
                      Text(
                        'Localização',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.redAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed:
                            () => controller.selectVehicleBottomSheet(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.solarYellow,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: Text(
                          "Solicitar entrada",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
