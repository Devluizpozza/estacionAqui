import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/collections_ref.dart';
import 'package:estacionaqui/app/models/ticket_model.dart';
import 'package:estacionaqui/app/utils/logger.dart';

class TicketRepository {
  TicketRepository();

  Future<bool> create(String parkingUID, Ticket ticket) async {
    try {
      await CollectionsRef.parking
          .doc(parkingUID)
          .collection(Collections.ticket)
          .doc(ticket.uid)
          .set(ticket.toJson());

      return true;
    } catch (e) {
      Logger.info(e.toString());
      return false;
    }
  }

  Future<bool> remove(String parkingUID, String payerUID) async {
    try {
      final querySnapshot =
          await CollectionsRef.parking
              .doc(parkingUID)
              .collection(Collections.ticket)
              .where('payerUID', isEqualTo: payerUID)
              .get();

      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      return true;
    } catch (e) {
      Logger.info(e.toString());
      return false;
    }
  }

  Future<List<Ticket>> list(String parkingUID) async {
    try {
      final query =
          await CollectionsRef.parking
              .doc(parkingUID)
              .collection(Collections.ticket)
              .get();

      return query.docs.map((doc) => Ticket.fromJson(doc.data())).toList();
    } catch (e) {
      Logger.info(e.toString());
      return [];
    }
  }

  // Future<int> sumTotalTicketByDay(String parkingUID) async {
  //   try {
  //     final querySnapshot =
  //         await CollectionsGroupRef.follower
  //             .where('uid', isEqualTo: parkingUID)
  //             .get();

  //     return querySnapshot.docs.length;
  //   } catch (e, s) {
  //     Logger.info('Erro ao contar followers: $e\n$s');
  //     return 0;
  //   }
  // }
}
