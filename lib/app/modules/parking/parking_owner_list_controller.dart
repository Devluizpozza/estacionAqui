import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/modules/user/user_controller.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/repositories/parking_repository.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ParkingOwnerListController extends GetxController {
  final Rx<List<Parking>> _parkings = Rx<List<Parking>>([]);
  final ParkingRepository parkingRepository = ParkingRepository();
  final AppUserRepository appUserRepository = AppUserRepository();
  final RxBool _isLoading = false.obs;

  List<Parking> get parkings => _parkings.value;

  set parkings(List<Parking> value) {
    _parkings.value = value;
    _parkings.refresh();
  }

  bool get isLoading => _isLoading.value;

  set isLoading(bool value) {
    _isLoading.value = value;
    _isLoading.refresh();
  }

  @override
  void onInit() async {
    isLoading = true;
    await listParkings();
    isLoading = false;
    super.onInit();
  }

  Future<void> listParkings() async {
    String userUID = UserController.instance.user!.uid;
    try {
      List<Parking>? parkingsRemote = await parkingRepository.listByOwner(
        userUID,
      );
      parkings = parkingsRemote;
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
