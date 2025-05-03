import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/log_model.dart';
import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/models/ticket_model.dart';
import 'package:estacionaqui/app/models/vehicle_model.dart';
import 'package:estacionaqui/app/modules/user/user_controller.dart';
import 'package:estacionaqui/app/repositories/log_repository.dart';
import 'package:estacionaqui/app/repositories/ticket_repository.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:get/get.dart';

class ParkingFinancialController extends GetxController {
  final Rx<String> _parkingName = Rx<String>('');
  final Rx<int> _totalMoneyToday = Rx<int>(0);
  final TicketRepository ticketRepository = TicketRepository();
  final LogRepository logRepository = LogRepository();
  final Rx<List<Ticket>> _tickets = Rx<List<Ticket>>(<Ticket>[]);
  final Rx<List<Log>> _logs = Rx<List<Log>>(<Log>[]);
  final Rx<int> _slotsOccuped = Rx<int>(0);
  late Parking parking;

  String get parkingUID => parking.uid;

  String get meUID => UserController.instance.user!.uid;

  String get parkingName => _parkingName.value;

  int get slotsOccuped => _slotsOccuped.value;

  set slotsOccuped(int value) {
    _slotsOccuped.value = value;
    _slotsOccuped.refresh();
  }

  set parkingName(String value) {
    _parkingName.value = value;
    _parkingName.refresh();
  }

  int get totalMoneyToday => _totalMoneyToday.value;

  set totalMoneyToday(int value) {
    _totalMoneyToday.value = value;
    _totalMoneyToday.refresh();
  }

  List<Ticket> get tickets => _tickets.value;

  set tickets(List<Ticket> value) {
    _tickets.value = value;
    _tickets.refresh();
  }

  List<Log> get logs => _logs.value;

  set logs(List<Log> value) {
    _logs.value = value;
    _logs.refresh();
  }

  @override
  void onInit() async {
    final Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      parkingName = arguments["parkingName"];
      parking = arguments["parking"];
    }
    await handleLists();
    super.onInit();
  }

  Future<void> handleLists() async {
    try {
      await listTickets();
      await listLog();
      List<Ticket> ticketsToFilter =
          tickets
              .where((ticket) => ticket.stype == StatusType.active.name)
              .toList();
      slotsOccuped = ticketsToFilter.length;
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> listTickets() async {
    try {
      tickets = await ticketRepository.list(parkingUID);
      _tickets.refresh();
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> removeTicket(String ticketUID) async {
    try {
      bool success = await ticketRepository.remove(parkingUID, ticketUID);
      if (success) {
        _tickets.refresh();
      }
      await listTickets();
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> handleEntry(
    Ticket ticket,
    Map<String, dynamic> changes,
    bool shouldExit,
  ) async {
    try {
      bool success = await ticketRepository.updateOnly(
        parkingUID,
        ticket.uid,
        changes,
      );
      if (success) {
        if (shouldExit) {
          SnackBarHandler.snackBarError(
            "Veículo ${ticket.vehicle.plate} saiu do estacionamento.",
          );
        } else {
          SnackBarHandler.snackBarSuccess(
            "Veículo ${ticket.vehicle.plate} estacionado.",
          );
        }
      }
      await listTickets();
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> createLog(
    ActionType actionType,
    Vehicle vehicle, {
    Map<String, dynamic>? metaData,
  }) async {
    try {
      Log logToSave = Log(
        uid: DB.generateUID(Collections.log),
        userUID: meUID,
        targetId: parkingUID,
        actionType: actionType,
        createdAt: DateTime.now(),
        metadata: metaData ?? {"vehicle": vehicle.toJson(), "value": 0.0},
      );
      bool success = await logRepository.create(logToSave);
      if (success) {
        await handleLists();
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> listLog() async {
    try {
      logs = await logRepository.listByParking(parkingUID);
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
