import 'package:estacionaqui/app/services/auth_manager.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ParkingOwnerView extends StatelessWidget {
  const ParkingOwnerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.lightBlue),
              child: Text(
                'nome do estacionamento',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Estatísticas'),
            ),
            const ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Reservas Atuais'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
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
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'nome do estacionamento',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
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
}
