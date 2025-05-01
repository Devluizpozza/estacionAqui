import 'package:estacionaqui/app/models/ticket_model.dart';
import 'package:estacionaqui/app/repositories/ticket_repository.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:get/get.dart';

class ParkingFinancialController extends GetxController {
  final Rx<String> _parkingName = Rx<String>('');
  final Rx<int> _totalMoneyToday = Rx<int>(0);
  final TicketRepository ticketRepository = TicketRepository();
  final Rx<List<Ticket>> _tickets = Rx<List<Ticket>>(<Ticket>[]);
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

  List<Ticket> get tickets => _tickets.value;

  set tickets(List<Ticket> value) {
    _tickets.value = value;
    _tickets.refresh();
  }

  @override
  void onInit() async {
    final Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      parkingName = arguments["parkingName"];
      parkingUID = arguments["parkingUID"];
    }
    await listTickets();
    super.onInit();
  }

  Future<void> listTickets() async {
    try {
      tickets = await ticketRepository.list(parkingUID);
      _tickets.refresh();
    } catch (e) {
      Logger.info(e.toString());
    }
  }
}
