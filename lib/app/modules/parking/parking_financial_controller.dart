// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:estacionaqui/app/components/input_box.dart';
import 'package:estacionaqui/app/components/input_text.dart';
import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/handlers/bottom_sheet_handler.dart';
import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/log_model.dart';
import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/models/ticket_model.dart';
import 'package:estacionaqui/app/models/vehicle_model.dart';
import 'package:estacionaqui/app/modules/user/user_controller.dart';
import 'package:estacionaqui/app/repositories/log_repository.dart';
import 'package:estacionaqui/app/repositories/parking_repository.dart';
import 'package:estacionaqui/app/repositories/ticket_repository.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:estacionaqui/app/utils/fomatter.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingFinancialController extends GetxController {
  final Rx<String> _parkingName = Rx<String>('');
  final Rx<int> _totalMoneyToday = Rx<int>(0);
  final TicketRepository ticketRepository = TicketRepository();
  final LogRepository logRepository = LogRepository();
  final ParkingRepository parkingRepository = ParkingRepository();
  final Rx<List<Ticket>> _tickets = Rx<List<Ticket>>(<Ticket>[]);
  final Rx<List<Log>> _logs = Rx<List<Log>>(<Log>[]);
  final Rx<int> _slotsOccuped = Rx<int>(0);
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController carValueController = TextEditingController();
  final TextEditingController motoValueController = TextEditingController();
  final Rx<Parking> _parking = Rx<Parking>(Parking.empty());
  final Rx<double> _totalValue = Rx<double>(0.0);

  String get parkingUID => parking.uid;

  String get meUID => UserController.instance.user!.uid;

  Parking get parking => _parking.value;

  set parking(Parking value) {
    _parking.value = value;
    _parking.refresh();
  }

  int get slotsOccuped => _slotsOccuped.value;

  set slotsOccuped(int value) {
    _slotsOccuped.value = value;
    _slotsOccuped.refresh();
  }

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

  double get totalValue => _totalValue.value;

  set totalValue(double value) {
    _totalValue.value = value;
    _totalValue.refresh();
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

      totalValue = tickets
          .map((ticket) => ticket.value)
          .fold(0.0, (prev, curr) => prev + curr);
    } catch (e) {
      Logger.info(e.toString());
      totalValue = 0.0;
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
        metadata: metaData ?? {"vehicle": vehicle.toJson()},
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

  void populateInputs() {
    double? carValue = double.tryParse(
      carValueController.text.replaceAll(',', '.'),
    );
    double? motoValue = double.tryParse(
      motoValueController.text.replaceAll(',', '.'),
    );
    displayNameController.text = parking.displayName;
    descriptionController.text = parking.description;
    phoneController.text = Formatter.formatPhone(
      parking.phone.replaceAll("+55", ""),
    );
    carValueController.text = parking.carValue.toString();
    motoValueController.text = parking.motoValue.toString();
  }

  Future<void> updateParkingData() async {
    try {
      double? carValue = double.tryParse(
        carValueController.text.replaceAll(',', '.'),
      );
      double? motoValue = double.tryParse(
        motoValueController.text.replaceAll(',', '.'),
      );
      Get.back();
      Map<String, dynamic> changes = {
        "displayName": displayNameController.text,
        "description": descriptionController.text,
        "phone": phoneController.text,
        "carValue": carValue,
        "motoValue": motoValue,
      };
      bool success = await parkingRepository.updateOnly(parking.uid, changes);
      if (success) {
        SnackBarHandler.snackBarSuccess("Dados atualizados");
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> updateParkingBottomSheet(BuildContext context) async {
    await refreshParking();
    populateInputs();
    return BottomSheetHandler.showSimpleBottomSheet(
      context,
      initialChildSize: 0.7,
      Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            spacing: 10,
            children: [
              const SizedBox(height: 20),
              Text(
                "Editar dados do estacionamento",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              InputText(
                label: "DisplayName",
                controller: displayNameController,
              ),
              InputBox(label: "Description", controller: descriptionController),
              InputText(label: "(00) 00000-0000", controller: phoneController),
              Row(
                children: [
                  Expanded(
                    child: InputText(
                      label: "Valor carro",
                      controller: carValueController,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InputText(
                      label: "Valor moto",
                      controller: motoValueController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => updateParkingData(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppColors.lightBlue,
                    ),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: Text("Atualizar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> refreshParking() async {
    try {
      parking = await parkingRepository.fetch(parking.uid);
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> updateTicket(
    String ticketUID,
    Map<String, dynamic> changes,
  ) async {
    try {
      bool success = await ticketRepository.updateOnly(
        parkingUID,
        ticketUID,
        changes,
      );
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
