import 'package:get/get.dart';

class ParkingDetailsController extends GetxController {
  final Rx<String> _parkingName = Rx<String>('');
  final Rx<int> _totalMoneyToday = Rx<int>(0);
  late String parkingUID;

  String get parkingName => _parkingName.value;

  set parkingName(String value) {
    _parkingName.value = value;
    _parkingName.refresh();
  }

  int get totalMoneyToday => _totalMoneyToday.value;

  set totalMoneyToday(int value) {
    _totalMoneyToday.value = value;
    _totalMoneyToday.refresh();
  }

  @override
  void onInit() {
    final Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      print(arguments);
      parkingName = arguments["parkingName"];
      parkingUID = arguments["parkingUID"];
    }
    super.onInit();
  }
}
