import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/models/vehicle_model.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final bool isCar = vehicle.vehicleType == VehicleType.car;
    final String formattedDate = DateFormat(
      'dd/MM/yyyy - HH:mm',
    ).format(vehicle.createAt);

    return Card(
      color: AppColors.lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Círculo com cor do veículo
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _parseColor(
                  vehicle.vehicleColor,
                ), 
              ),
            ),
            const SizedBox(width: 16),
            // Detalhes do veículo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.plate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        isCar ? Icons.directions_car : Icons.motorcycle,
                        size: 18,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 6),
                      _buildBrandIcon(),
                      const SizedBox(width: 8),
                      Text(
                        _getBrandName(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Data/Hora
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formattedDate,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorCode) {
    try {
      return Color(int.parse(colorCode.replaceAll('#', '0xff')));
    } catch (_) {
      return Colors.grey;
    }
  }

  Widget _buildBrandIcon() {
    final IconData icon = Icons.directions_car_filled; // mock
    return Icon(icon, size: 18, color: Colors.black54);
  }

  String _getBrandName() {
    if (vehicle.vehicleType == VehicleType.car) {
      return vehicle.carMarkType?.name ?? 'Desconhecida';
    } else {
      return vehicle.motoMarkType?.name ?? 'Desconhecida';
    }
  }
}
