import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo ou imagem ilustrativa
            Image.asset('assets/images/logo_car.png', height: 100),
            const SizedBox(height: 32),

            // Indicador de progresso
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.solarYellow),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),

            // Texto de carregamento
            Text(
              "Carregando...",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
