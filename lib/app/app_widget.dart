import 'package:estacionaqui/app/routes/app_pages.dart';
import 'package:estacionaqui/app/routes/app_routes.dart';
import 'package:estacionaqui/app/services/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppWidget extends StatelessWidget {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  AppWidget({super.key}) {
    // Get.put<RouteObserver<PageRoute>>(routeObserver);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Portfólio Mobile',
      locale: Locale('pt', 'BR'),
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthManager());
      }),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.initial,
      fallbackLocale: Locale('pt', 'BR'),
      navigatorObservers: [routeObserver],
    );
  }
}
