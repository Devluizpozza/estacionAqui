import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/handlers/bottom_sheet_handler.dart';
import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/models/ticket_model.dart';
import 'package:estacionaqui/app/modules/user/user_controller.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/repositories/parking_repository.dart';
import 'package:estacionaqui/app/repositories/ticket_repository.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingOwnerListController extends GetxController {
  final Rx<List<Parking>> _parkings = Rx<List<Parking>>([]);
  final ParkingRepository parkingRepository = ParkingRepository();
  final AppUserRepository appUserRepository = AppUserRepository();
  final TicketRepository ticketRepository = TicketRepository();
  final RxMap<String, int> occupedSlotsMap = <String, int>{}.obs;
  final RxBool _isLoading = false.obs;
  final Rx<double> _totalValue = Rx<double>(0.0);

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

  double get totalValue => _totalValue.value;

  set totalValue(double value) {
    _totalValue.value = value;
    _totalValue.refresh();
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

      for (Parking parking in parkingsRemote) {
        int occupedSlots = await listActiveTickets(parking.uid);
        occupedSlotsMap[parking.uid] = occupedSlots;
        await listTotalValueTickets(parking.uid);
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> onRefresh() async {
    await listParkings();
  }

  void parkingOptionOnLongPressed(BuildContext context, Parking parking) {
    BottomSheetHandler.showConfirmationBottomSheet(
      title: "Deseja excluir ${parking.displayName}?",
      confirmText: "Excluir",
      confirmColor: Colors.red,
      cancelText: "cancel",
      onCancel: () => Get.back(),
      context: Get.context!,
      onConfirm: () async {
        await deleteParking(parking.uid);
        await onRefresh();
      },
    );
  }

  Future<void> deleteParking(String parkingUID) async {
    try {
      bool success = await parkingRepository.delete(parkingUID);
      if (success) {
        SnackBarHandler.snackBarSuccess("Estacionamento removido");
      }
      {}
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<int> listActiveTickets(String parkingUID) async {
    try {
      List<Ticket> remoteTickets = await ticketRepository.list(parkingUID);
      if (remoteTickets.isNotEmpty) {
        List<Ticket> ticketsFiltered =
            remoteTickets
                .where((ticket) => ticket.statusType == StatusType.active)
                .toList();
        return ticketsFiltered.length;
      }
      return 0;
    } catch (e) {
      Logger.info(e.toString());
      return 0;
    }
  }

  Future<double> listTotalValueTickets(String parkingUID) async {
    try {
      final List<Ticket> remoteTickets = await ticketRepository.list(
        parkingUID,
      );

      if (remoteTickets.isNotEmpty) {
        final now = DateTime.now();
        final startOfDay = DateTime(now.year, now.month, now.day);
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

        final ticketsToday = remoteTickets.where((ticket) {
          final date = ticket.createAt;
          return date.isAfter(startOfDay) && date.isBefore(endOfDay);
        });

        totalValue = ticketsToday.fold<double>(
          0.0,
          (sum, ticket) => sum + ticket.value,
        );

        return totalValue;
      }

      return 0.0;
    } catch (e) {
      Logger.info(e.toString());
      return 0.0;
    }
  }
}
