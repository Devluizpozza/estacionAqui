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
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingDetailController extends GetxController {
  final ParkingRepository parkingRepository = ParkingRepository();
  final AppUserRepository userRepository = AppUserRepository();
  final FollowerRepository followerRepository = FollowerRepository();
  final TicketRepository ticketRepository = TicketRepository();
  final LogRepository logRepository = LogRepository();

  final RxMap<String, bool> followingStatus = <String, bool>{}.obs;
  final Vehicle vehicle = Vehicle(
    uid: DB.generateUID(Collections.vehicle),
    userUID: "plne9b7A6mS2qmCjrmisyvytvg03",
    plate: "CDF2222",
    vehicleColor: "#ffffff",
    vehicleType: VehicleType.car,
    carMarkType: CarMarkType.audi,
    createAt: DateTime.now(),
  );
  late Parking parking;
  final RxBool _isFollowing = false.obs;
  final RxBool _isLoading = false.obs;

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

  Future<void> createTicket() async {
    try {
      Ticket ticketToSave = Ticket(
        uid: DB.generateUID(Collections.ticket),
        payerUID: userUID,
        description: "pagamento de entrada",
        value: 15.0,
        parkingUID: parking.uid,
        vehicleType: VehicleType.car,
        vehicle: vehicle,
        statusType: StatusType.pending,
        createAt: DateTime.now(),
      );
      bool success = await ticketRepository.create(parking.uid, ticketToSave);
      if (success) {
        SnackBarHandler.snackBarSuccess('$ticketToSave criado');
        await createLog(
          parking.uid,
          ActionType.request_entry,
          metaData: {"vehicle": vehicle.toJson(), "value": 15.0},
        );
      }
    } catch (e) {
      Logger.info(e.toString());
    }
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
      bool success = await logRepository.create(logToSave);
      if (success) {
        print(success);
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
