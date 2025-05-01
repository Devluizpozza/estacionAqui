import 'package:estacionaqui/app/components/ticket_card.dart';
import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/models/ticket_model.dart';
import 'package:estacionaqui/app/models/vehicle_model.dart';
import 'package:estacionaqui/app/modules/parking/parking_financial_controller.dart';
import 'package:estacionaqui/app/routes/app_routes.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingFinancialView extends GetView<ParkingFinancialController> {
  ParkingFinancialView({super.key});

  final mockTickets = [
    Ticket(
      uid: '1',
      value: 20.0,
      description: 'Entrada',
      payerUID: 'user1',
      parkingUID: 'park1',
      vehicleType: VehicleType.car,
      vehicle: Vehicle(
        plate: 'ABC1234',
        vehicleColor: '#3498db',
        vehicleType: VehicleType.car,
        carMarkType: CarMarkType.fiat,
        createAt: DateTime.now().subtract(const Duration(hours: 1)),
        uid: '',
        userUID: '',
      ),
      createAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Ticket(
      uid: '2',
      value: 25.0,
      description: 'Saída',
      payerUID: 'user2',
      parkingUID: 'park2',
      vehicleType: VehicleType.motorcycle,
      vehicle: Vehicle(
        plate: 'XYZ7890',
        vehicleColor: '#e74c3c',
        vehicleType: VehicleType.motorcycle,
        motoMarkType: MotoMarkType.honda,
        createAt: DateTime.now().subtract(const Duration(hours: 2)),
        uid: '',
        userUID: '',
      ),
      createAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

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
              leading: Icon(Icons.car_repair),
              title: Text('Estacionamentos'),
              onTap: () => Get.toNamed(AppRoutes.parking_owner_list),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('veiculos'),
              onTap: () => Get.toNamed(AppRoutes.vehicle_list),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
            ),
            ListTile(leading: Icon(Icons.help), title: Text('Ajuda')),
          ],
        ),
      ),
      appBar: AppBar(
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
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => showRightSideSheet(context),
                  child: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    radius: 18,
                    child: Icon(
                      Icons.notifications,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
                Positioned(
                  top: -1,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.amberAccent,
                    radius: 8,
                    child: Text(
                      "7",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
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

            // Cards de valores
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: "Lucro Hoje",
                    value: "R\$ 320,00",
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: "Vagas Ocupadas",
                    value: "12/20",
                    icon: Icons.local_parking,
                    color: Colors.orange,
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
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.directions_car),
                    title: Text("Carro entrou - Placa ABC1234"),
                    subtitle: Text("10:32 AM"),
                    trailing: Text("+ R\$ 20,00"),
                  ),
                  ListTile(
                    leading: Icon(Icons.directions_car),
                    title: Text("Carro saiu - Placa XYZ7890"),
                    subtitle: Text("09:10 AM"),
                    trailing: Text("+ R\$ 25,00"),
                  ),
                  ListTile(
                    leading: Icon(Icons.directions_car),
                    title: Text("Reserva confirmada - João S."),
                    subtitle: Text("08:00 AM"),
                    trailing: Text("+ R\$ 30,00"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                // ignore: deprecated_member_use
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
            child: RefreshIndicator(
              onRefresh: () => controller.listTickets(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.tickets.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final ticket = controller.tickets[index];
                          return TicketCard(ticket: ticket);
                        },
                      ),
                    ),
                  ],
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
}
