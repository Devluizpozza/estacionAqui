import 'package:estacionaqui/app/models/vehicle_model.dart';
import 'package:flutter/material.dart';

import 'vehicle_card.dart';

class DropDownVehicle extends StatelessWidget {
  final Vehicle? selectedVehicle;
  final List<Vehicle> vehicles;
  final void Function(Vehicle) onSelected;
  final bool? shouldShowVehicleCard;

  const DropDownVehicle({
    super.key,
    required this.selectedVehicle,
    required this.vehicles,
    required this.onSelected,
    this.shouldShowVehicleCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showVehicleMenu(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: !shouldShowVehicleCard! ? Colors.grey : Colors.white,
          ),
        ),
        child: Visibility(
          visible: !shouldShowVehicleCard!,
          replacement: VehicleCard(vehicle: selectedVehicle ?? Vehicle.empty()),
          child: Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedVehicle?.plate ?? 'Selecione um veículo',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  void _showVehicleMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => DraggableScrollableSheet(
            expand: false,
            builder:
                (context, scrollController) => ListView.builder(
                  controller: scrollController,
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onSelected(vehicle);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: VehicleCard(vehicle: vehicle),
                      ),
                    );
                  },
                ),
          ),
    );
  }
}
