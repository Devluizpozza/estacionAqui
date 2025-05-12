// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: deprecated_member_use

import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/models/ticket_model.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  void Function()? onTap;
  void Function()? onLongPress;

  TicketCard({super.key, required this.ticket, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final vehicle = ticket.vehicle;
    final isCar = vehicle.vehicleType == VehicleType.car;

    return Material(
      elevation: 3,
      color: AppColors.lightBlue.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getStatusColor(ticket.statusType),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.plate,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(
                          isCar ? Icons.directions_car : Icons.motorcycle,
                          size: 16,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isCar
                              ? (vehicle.carMarkType?.name ?? 'Desconhecido')
                              : (vehicle.motoMarkType?.name ?? 'Desconhecido'),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('dd/MM HH:mm').format(ticket.createAt),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    "R\$ ${ticket.value}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getStatusColor(StatusType statusType) {
    switch (statusType) {
      case StatusType.active:
        return Colors.green;
      case StatusType.pending:
        return Colors.orange;
      case StatusType.desactive:
        return Colors.red;
      default:
        return Colors.red;
    }
  }
}
