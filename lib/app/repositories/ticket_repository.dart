import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/collections_group_ref.dart';
import 'package:estacionaqui/app/db/collections_ref.dart';
import 'package:estacionaqui/app/models/follower.dart';
import 'package:estacionaqui/app/utils/logger.dart';

class TicketRepository {
  TicketRepository();

  Future<bool> createFollower(String parkingUID, Follower follower) async {
    try {
      await CollectionsRef.parking
          .doc(parkingUID)
          .collection(Collections.follower)
          .doc(follower.uid)
          .set(follower.toJson());

      return true;
    } catch (e, s) {
      Logger.info('Erro ao contar followers: $e\n$s');
      return false;
    }
  }

  Future<bool> removeFollower(String parkingUID, String userUID) async {
    try {
      final querySnapshot =
          await CollectionsRef.parking
              .doc(parkingUID)
              .collection(Collections.follower)
              .where('userUID', isEqualTo: userUID)
              .get();

      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      return true;
    } catch (e, s) {
      Logger.info('Erro ao remover follower: $e\n$s');
      return false;
    }
  }

  Future<int> sumFollowersByParking(String parkingUID) async {
    try {
      final querySnapshot =
          await CollectionsGroupRef.follower
              .where('uid', isEqualTo: parkingUID)
              .get();

      return querySnapshot.docs.length;
    } catch (e, s) {
      Logger.info('Erro ao contar followers: $e\n$s');
      return 0;
    }
  }
}
