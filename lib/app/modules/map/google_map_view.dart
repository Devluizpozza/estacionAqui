import 'package:estacionaqui/app/components/loading_widget.dart';
import 'package:estacionaqui/app/modules/map/google_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends GetView<GoogleMapsController> {
  const GoogleMaps({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return !controller.isLoading
          ? Scaffold(
            appBar: AppBar(title: const Text("Mapa")),
            body: Obx(() {
              final position = controller.currentPosition.value;

              if (position == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return GoogleMap(
                onMapCreated: controller.setMapController,
                initialCameraPosition: CameraPosition(
                  target: position,
                  zoom: 15,
                ),
                myLocationEnabled: true,
                markers: controller.markers,
              );
            }),
          )
          : LoadingWidget();
    });
  }
}
