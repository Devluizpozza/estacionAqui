// ignore_for_file: deprecated_member_use

import 'package:estacionaqui/app/components/ticket_card.dart';
import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/handlers/bottom_sheet_handler.dart';
import 'package:estacionaqui/app/models/log_model.dart';
import 'package:estacionaqui/app/models/ticket_model.dart';
import 'package:estacionaqui/app/models/vehicle_model.dart';
import 'package:estacionaqui/app/modules/parking/parking_financial_controller.dart';
import 'package:estacionaqui/app/routes/app_routes.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ParkingFinancialView extends GetView<ParkingFinancialController> {
  const ParkingFinancialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF4FC3F7)),
              child: Text(
                'EstacionAqui',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.house),
              title: Text('Inicio'),
              onTap: () => Get.toNamed(AppRoutes.home),
            ),
            ListTile(
              leading: Icon(Icons.car_repair),
              title: Text('Estacionamentos'),
              onTap: () => Get.toNamed(AppRoutes.parking_owner_list),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('veiculos'),
              onTap: () => Get.toNamed(AppRoutes.vehicle_list),
            ),
            ListTile(leading: Icon(Icons.help), title: Text('Ajuda')),
          ],
        ),
      ),
      appBar: AppBar(
        titleSpacing: 10,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          controller.parkingName,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.settings, size: 28),
              onPressed: () => controller.updateParkingBottomSheet(context),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📊 Visão Geral Financeira",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Obx(
                  () => Expanded(
                    child: _buildStatCard(
                      title: "Lucro Hoje",
                      value: "R\$ ${controller.totalValue}",
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => _buildStatCard(
                      title: "Vagas Ocupadas",
                      value:
                          "${controller.slotsOccuped}/${controller.parking.slots}",
                      icon: Icons.local_parking,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            const Text(
              "🧾 Últimas Atividades",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Obx(
                () => RefreshIndicator(
                  onRefresh: () => controller.listLog(),
                  child: ListView.builder(
                    itemCount: controller.logs.length,
                    itemBuilder: (context, index) {
                      Log log = controller.logs[index];
                      Vehicle vehicle = Vehicle.fromJson(
                        log.metadata!["vehicle"],
                      );
                      double value = log.metadata!["value"];
                      return ListTile(
                        leading: Icon(
                          vehicle.vehicleType == VehicleType.car
                              ? Icons.directions_car
                              : Icons.motorcycle,
                        ),
                        title: Text(
                          "${vehicle.vehicleType == VehicleType.car ? "Carro" : "Moto"} ${vehicle.plate} ${handleActionTypeName(log.actionType)}",
                        ),
                        subtitle: Text(
                          DateFormat('dd/MM HH:mm').format(log.createdAt),
                        ),
                        trailing: Text("+ R\$ $value"),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showRightSideSheet(context),
        backgroundColor: AppColors.lightBlue,
        child: const Icon(
          Icons.car_crash_rounded,
          color: Colors.blueGrey,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 85,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  void showRightSideSheet(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Tickets",
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.centerRight,
          child: SafeArea(
            child: Material(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.black,
                        tabs: [
                          Tab(text: "entrada"),
                          Tab(text: "Pendentes"),
                          Tab(text: "Saída"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => controller.listTickets(),
                          child: Obx(() {
                            final allTickets = controller.tickets;
                            final fila =
                                allTickets
                                    .where(
                                      (t) => t.statusType == StatusType.active,
                                    )
                                    .toList();
                            final pendentes =
                                allTickets
                                    .where(
                                      (t) => t.statusType == StatusType.pending,
                                    )
                                    .toList();
                            final saida =
                                allTickets
                                    .where(
                                      (t) =>
                                          t.statusType == StatusType.desactive,
                                    )
                                    .toList();
                            return TabBarView(
                              children: [
                                _buildTicketList(context, fila),
                                _buildTicketList(context, pendentes),
                                _buildTicketList(context, saida),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        );
      },
    );
  }

  Widget _buildTicketList(BuildContext context, List<Ticket> tickets) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return TicketCard(
          ticket: ticket,
          onTap: () {
            handleStatus(ticket.statusType, context, ticket, ticket.vehicle);
          },
        );
      },
    );
  }

  void handleStatus(
    StatusType statusType,
    BuildContext context,
    Ticket ticket,
    Vehicle vehicle,
  ) {
    switch (statusType) {
      case StatusType.active:
        return BottomSheetHandler.showConfirmationBottomSheet(
          context: context,
          title: "registrar saída",
          confirmColor: Colors.red,
          confirmText: "registrar saída",
          cancelText: "Cancelar",
          onConfirm: () {
            controller.handleEntry(ticket, {
              "description": "saiu",
              "statusType": StatusType.desactive.name,
            }, true);
            controller.createLog(ActionType.vehicle_exit, vehicle);
          },
          onCancel: () => Get.back(),
        );
      case StatusType.pending:
        return BottomSheetHandler.showConfirmationBottomSheet(
          context: context,
          shouldShowExtraButton: true,
          title: "",
          confirmColor: Colors.green,
          confirmText: "registrar entrada",
          extraButtonColor: Colors.red,
          extraButtonText: "recusar",
          cancelText: "Cancelar",
          onConfirm: () {
            controller.handleEntry(ticket, {
              "description": "entrou",
              "statusType": StatusType.active.name,
            }, false);
            controller.createLog(
              ActionType.request_accepted,
              vehicle,
              metaData: {
                "value":
                    ticket.vehicleType == VehicleType.car
                        ? controller.parking.carValue
                        : controller.parking.motoValue,
                "vehicle": vehicle.toJson(),
              },
            );
            controller.updateTicket(ticket.uid, {
              "value":
                  ticket.vehicleType == VehicleType.car
                      ? controller.parking.carValue
                      : controller.parking.motoValue,
            });
          },
          onExtraButton: () {
            controller.removeTicket(ticket.uid);
            controller.createLog(ActionType.request_refused, vehicle);
          },
          onCancel: () => Get.back(),
        );
      case StatusType.desactive:
        return BottomSheetHandler.showConfirmationBottomSheet(
          context: context,
          title: "",
          confirmColor: Colors.red,
          confirmText: "excluir ticket",
          cancelText: "Cancelar",
          onConfirm: () {
            controller.removeTicket(ticket.uid);
          },
          onCancel: () => Get.back(),
        );
      case StatusType.none:
        return BottomSheetHandler.showConfirmationBottomSheet(
          context: context,
          title: "nao deveria aparecer",
          confirmColor: Colors.red,
          confirmText: "excluir ticket",
          cancelText: "Cancelar",
          onConfirm: () {
            controller.removeTicket(ticket.uid);
          },
          onExtraButton: () => controller.removeTicket(ticket.payerUID),
          onCancel: () => Get.back(),
        );
    }
  }

  String handleActionTypeName(ActionType actionType) {
    switch (actionType) {
      case ActionType.request_entry:
        return "solicitou entrada";
      case ActionType.request_accepted:
        return "solicitação aceita";
      case ActionType.request_refused:
        return "solicitação recusada";
      case ActionType.vehicle_exit:
        return "saiu";
      case ActionType.vehicle_entry:
        return "entrou";
      default:
        return "";
    }
  }
}
