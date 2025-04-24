import 'package:estacionaqui/app/routes/app_routes.dart';
import 'package:estacionaqui/app/services/auth_manager.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingOwnerList extends StatelessWidget {
  const ParkingOwnerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "🅿️ Meus Estacionamentos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildParkingCard(
              title: "Estacionamento Copacabana",
              spots: "15/20 vagas",
              earnings: "R\$ 540,00 hoje",
              onTap: () => Get.toNamed(AppRoutes.parking_owner),
            ),
            const SizedBox(height: 12),
            _buildParkingCard(
              title: "Estacionamento Leblon",
              spots: "8/10 vagas",
              earnings: "R\$ 320,00 hoje",
            ),
            const SizedBox(height: 12),
            _buildParkingCard(
              title: "Estacionamento Centro",
              spots: "20/25 vagas",
              earnings: "R\$ 680,00 hoje",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aqui você pode chamar uma rota para adicionar novo estacionamento
          // Ex: Get.toNamed(AppRoutes.addParking);
        },
        backgroundColor: AppColors.lightBlue,
        child: const Icon(Icons.add, color: Colors.white),
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
