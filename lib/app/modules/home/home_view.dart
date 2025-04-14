import 'package:estacionaqui/app/components/location_card.dart';
import 'package:estacionaqui/app/components/quick_action_card.dart';
import 'package:estacionaqui/app/modules/home/home_controller.dart';
import 'package:estacionaqui/app/routes/app_routes.dart';
import 'package:estacionaqui/app/services/auth_manager.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

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
            ListTile(leading: Icon(Icons.star), title: Text('Favoritos')),
            ListTile(leading: Icon(Icons.history), title: Text('Histórico')),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
            ),
            ListTile(leading: Icon(Icons.help), title: Text('Ajuda')),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sair'),
              onTap: () => AuthManager.instance.signOut(),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'EstacionAqui',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              child: CircleAvatar(
                backgroundColor: AppColors.lightBlue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              onTap: () => Get.toNamed(AppRoutes.user_profile),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "👋 Olá, pronto para estacionar perto da praia?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Encontre o melhor estacionamento com poucos toques.",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),

                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(Icons.map, size: 50, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.map),
                  icon: const Icon(Icons.search),
                  label: const Text("Procurar Estacionamentos Agora"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEB3B),
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  "Ações Rápidas",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    QuickActionCard(icon: Icons.star, label: 'Favoritos'),
                    QuickActionCard(icon: Icons.history, label: 'Recentes'),
                    QuickActionCard(
                      icon: Icons.attach_money,
                      label: 'Economia',
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                const Text(
                  "Descubra por localidade",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const SizedBox(height: 12),

                Column(
                  children: const [
                    LocationCard(title: 'Praia de Ipanema'),
                    LocationCard(title: 'Barra da Tijuca'),
                    LocationCard(title: 'Praia Grande'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: FloatingActionButton(
          backgroundColor: AppColors.lightBlue,
          onPressed: () => Get.toNamed(AppRoutes.map),
          child: const Icon(Icons.map, color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
