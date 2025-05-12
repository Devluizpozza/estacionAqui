// ignore_for_file: use_build_context_synchronously

import 'package:estacionaqui/app/components/drop_down_vehicle.dart';
import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/handlers/bottom_sheet_handler.dart';
import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/app_user_model.dart';
import 'package:estacionaqui/app/models/follower.dart';
import 'package:estacionaqui/app/models/log_model.dart';
import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/models/ticket_model.dart';
import 'package:estacionaqui/app/models/vehicle_model.dart';
import 'package:estacionaqui/app/modules/user/user_controller.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/repositories/follower_repository.dart';
import 'package:estacionaqui/app/repositories/log_repository.dart';
import 'package:estacionaqui/app/repositories/parking_repository.dart';
import 'package:estacionaqui/app/repositories/ticket_repository.dart';
import 'package:estacionaqui/app/repositories/vehicle_repository.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingDetailController extends GetxController {
  final ParkingRepository parkingRepository = ParkingRepository();
  final AppUserRepository userRepository = AppUserRepository();
  final FollowerRepository followerRepository = FollowerRepository();
  final TicketRepository ticketRepository = TicketRepository();
  final LogRepository logRepository = LogRepository();
  final VehicleRepository vehicleRepository = VehicleRepository();
  final RxMap<String, bool> followingStatus = <String, bool>{}.obs;
  final Rx<Vehicle> _vehicle = Rx<Vehicle>(Vehicle.empty());
  late Parking parking;
  final RxBool _isFollowing = false.obs;
  final RxBool _isLoading = false.obs;
  final Rx<List<Vehicle>> _vehicles = Rx<List<Vehicle>>(<Vehicle>[]);
  final Rx<Vehicle?> _selectedVehicle = Rx<Vehicle?>(null);

  @override
  void onInit() async {
    isLoading = true;
    final Map<String, dynamic>? arguments = Get.arguments;
    if (arguments != null) {
      parking = arguments['parking'];
    }
    await checkIfFollowing(parking.uid);
    isLoading = false;
    super.onInit();
  }

  String get userUID => UserController.instance.user!.uid;

  bool get isFollowing => _isFollowing.value;

  set isFollowing(bool value) {
    _isFollowing.value = value;
    _isFollowing.refresh();
  }

  bool get isLoading => _isLoading.value;

  set isLoading(bool value) {
    _isLoading.value = value;
    _isLoading.refresh();
  }

  List<Vehicle> get vehicles => _vehicles.value;

  set vehicles(List<Vehicle> value) {
    _vehicles.value = value;
    _vehicles.refresh();
  }

  Vehicle? get selectedVehicle => _selectedVehicle.value;

  set selectedVehicle(Vehicle? value) {
    _selectedVehicle.value = value;
    _selectedVehicle.refresh();
  }

  Vehicle get vehicle => _vehicle.value;

  set vehicle(Vehicle value) {
    _vehicle.value = value;
    _vehicle.refresh();
  }

  Future<void> createTicket() async {
    try {
      Ticket ticketToSave = Ticket(
        uid: DB.generateUID(Collections.ticket),
        payerUID: userUID,
        description: "pagamento de entrada",
        value: 0.0,
        parkingUID: parking.uid,
        vehicleType: selectedVehicle!.vehicleType,
        vehicle: selectedVehicle!,
        statusType: StatusType.pending,
        createAt: DateTime.now(),
      );
      bool success = await ticketRepository.create(parking.uid, ticketToSave);
      if (success) {
        Get.back();
        SnackBarHandler.snackBarSuccess('$ticketToSave criado');
        await createLog(
          parking.uid,
          ActionType.request_entry,
          metaData: {
            "vehicle": selectedVehicle!.toJson(),
            "value": ticketToSave.value,
          },
        );
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> selectVehicleBottomSheet(BuildContext context) async {
    await listVehicles();
    selectedVehicle = null;
    return BottomSheetHandler.showSimpleBottomSheet(
      context,
      initialChildSize: 0.5,
      Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              const SizedBox(height: 20),
              Obx(
                () => DropDownVehicle(
                  vehicles: vehicles,
                  onSelected: (vehicle) => selectedVehicle = vehicle,
                  selectedVehicle: selectedVehicle,
                  shouldShowVehicleCard: selectedVehicle != null,
                ),
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => createTicket(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppColors.lightBlue,
                    ),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: Text("selecionar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> listTickets() async {
    try {
      final List<Ticket> listTicket = await ticketRepository.list(parking.uid);
      if (listTicket.isNotEmpty) {
        // print(listTicket);
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> handleFollow() async {
    try {
      AppUser user = await userRepository.fetch(userUID);
      List<Follower> remoteFollower = await followerRepository.listFollowers(
        parking.uid,
      );
      Follower? meFollow = remoteFollower.firstWhereOrNull(
        (e) => e.userUID == userUID,
      );
      if (meFollow == null) {
        Follower followerToSave = Follower(
          uid: DB.generateUID(Collections.follower),
          userUID: userUID,
          userName: user.name,
          createAt: DateTime.now(),
        );
        await followerRepository.createFollower(parking.uid, followerToSave);
        isFollowing = true;
      } else {
        await followerRepository.removeFollower(parking.uid, userUID);
        isFollowing = false;
      }
      await checkIfFollowing(parking.uid);
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> checkIfFollowing(String parkingUID) async {
    try {
      final followers = await followerRepository.listFollowers(parkingUID);
      final isUserFollowing = followers.any(
        (follower) => follower.userUID == userUID,
      );
      followingStatus[parkingUID] = isUserFollowing;
      isFollowing = isUserFollowing;
      followingStatus.refresh();
    } catch (e) {
      Logger.info('Erro ao verificar se segue: $e');
    }
  }

  void showUnfollowOptions() {
    BottomSheetHandler.showConfirmationBottomSheet(
      context: Get.context!,
      title: "Deseja deixar de seguir?",
      confirmText: "Deixar de seguir",
      confirmColor: Colors.red,
      onCancel: () => Get.back(),
      onConfirm: () async {
        await handleFollow();
      },
    );
  }

  Future<void> createLog(
    String parkingUID,
    ActionType actionType, {
    Map<String, dynamic>? metaData,
  }) async {
    try {
      Log logToSave = Log(
        uid: DB.generateUID(Collections.log),
        userUID: userUID,
        targetId: parkingUID,
        actionType: actionType,
        createdAt: DateTime.now(),
        metadata: metaData,
      );
      await logRepository.create(logToSave);
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> listVehicles() async {
    try {
      vehicles = await vehicleRepository.list(userUID);
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
