import 'package:estacionaqui/app/components/loading_widget.dart';
import 'package:estacionaqui/app/components/map.dart';
import 'package:estacionaqui/app/modules/map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:latlong2/latlong.dart';

class MapView extends GetView<MapToViewController> {
  const MapView({super.key});

  void _locationSelected(LatLng latlng) {
    // Aqui você vai fazer algo com a localização clicada
    print('Local selecionado: ${latlng.latitude}, ${latlng.longitude}');
    // Exemplo: salvar no banco de dados ou no estado do app
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !controller.isLoading,
        replacement: LoadingWidget(),
        child: Scaffold(
          appBar: AppBar(title: Text('Mapa')),
          body: MapComponent(
            markers: controller.markers,
            onLocationSelected: _locationSelected,
          ),
        ),
      ),
    );
  }
}
