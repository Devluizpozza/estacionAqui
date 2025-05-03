import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/collections_ref.dart';
import 'package:estacionaqui/app/models/log_model.dart';
import 'package:estacionaqui/app/utils/logger.dart';

class LogRepository {
  LogRepository();

  Future<bool> create(Log log) async {
    try {
      await CollectionsRef.log.doc(log.uid).set(log);

      return true;
    } catch (e) {
      Logger.info(e.toString());
      return false;
    }
  }

  Future<bool> remove(String logUID) async {
    try {
      await CollectionsRef.log.doc(logUID).delete();
      return true;
    } catch (e) {
      Logger.info(e.toString());
      return false;
    }
  }

  Future<bool> updateOnly(
    String parkingUID,
    String ticketUID,
    Map<String, dynamic> changes,
  ) async {
    try {
      CollectionsRef.parking
          .doc(parkingUID)
          .collection(Collections.ticket)
          .doc(ticketUID)
          .update(changes);
      return true;
    } catch (e) {
      Logger.info(e);
      return false;
    }
  }

  Future<List<Log>> listByParking(String parkingUID) async {
    try {
      final query =
          await CollectionsRef.log
              .where("targetId", isEqualTo: parkingUID)
              .orderBy("createdAt", descending: true)
              .get();

      return query.docs.map((doc) => doc.data()).toList();
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
