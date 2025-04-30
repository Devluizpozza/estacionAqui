import 'package:estacionaqui/app/modules/home/home_bindings.dart';
import 'package:estacionaqui/app/modules/home/home_view.dart';
import 'package:estacionaqui/app/modules/login/login_bindings.dart';
import 'package:estacionaqui/app/modules/login/login_view.dart';
import 'package:estacionaqui/app/modules/login/register_user_bindings.dart';
import 'package:estacionaqui/app/modules/login/register_user_view.dart';
import 'package:estacionaqui/app/modules/map/map_bindings.dart';
import 'package:estacionaqui/app/modules/map/map_view.dart';
import 'package:estacionaqui/app/modules/parking/parking_add_bindings.dart';
import 'package:estacionaqui/app/modules/parking/parking_add_view.dart';
import 'package:estacionaqui/app/modules/parking/parking_detail_bindings.dart';
import 'package:estacionaqui/app/modules/parking/parking_detail_view.dart';
import 'package:estacionaqui/app/modules/parking/parking_details_bindings.dart';
import 'package:estacionaqui/app/modules/parking/parking_details_view.dart';
import 'package:estacionaqui/app/modules/parking/parking_owner_list_bindings.dart';
import 'package:estacionaqui/app/modules/parking/parking_owner_list_view.dart';
import 'package:estacionaqui/app/modules/sms/confirm_sms_code_bindings.dart';
import 'package:estacionaqui/app/modules/sms/confirm_sms_code_view.dart';
import 'package:estacionaqui/app/modules/user/user_profile/user_profile_bindings.dart';
import 'package:estacionaqui/app/modules/user/user_profile/user_profile_view.dart';
import 'package:estacionaqui/app/modules/vehicle/vehicle_list_bindings.dart';
import 'package:estacionaqui/app/modules/vehicle/vehicle_list_view.dart';
import 'package:estacionaqui/app/routes/app_routes.dart';
import 'package:estacionaqui/app/services/auth_state_widget.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

abstract class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: LoginBinginds(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: AppRoutes.register_user,
      page: () => RegisterUserView(),
      binding: RegisterUserBindings(),
    ),
    GetPage(name: AppRoutes.map, page: () => MapView(), binding: MapBindings()),
    GetPage(
      name: AppRoutes.user_profile,
      page: () => UserProfileView(),
      binding: UserProfileBindings(),
    ),
    GetPage(
      name: AppRoutes.confirm_sms_code,
      page: () => ConfirmSmsCodeView(),
      binding: ConfirmSmsCodeBindings(),
    ),
    GetPage(
      name: AppRoutes.parking_owner_list,
      page: () => ParkingOwnerList(),
      binding: ParkingOwnerBindings(),
    ),
    GetPage(
      name: AppRoutes.parking_financial,
      page: () => ParkingFinancialView(),
      binding: ParkingFinancialBindings(),
    ),
    GetPage(
      name: AppRoutes.parking_add,
      page: () => ParkingAddView(),
      binding: ParkingAddBindings(),
    ),
    GetPage(
      name: AppRoutes.parking_detail,
      page: () => ParkingDetailView(),
      binding: ParkingDetailBindings(),
    ),
    GetPage(
      name: AppRoutes.vehicle_list,
      page: () => VehicleListView(),
      binding: VehicleListBindings(),
    ),
    GetPage(name: AppRoutes.initial, page: () => AuthStateWidget()),
  ];
}
