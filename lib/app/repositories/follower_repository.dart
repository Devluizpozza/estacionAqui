import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/collections_group_ref.dart';
import 'package:estacionaqui/app/db/collections_ref.dart';
import 'package:estacionaqui/app/models/follower.dart';
import 'package:estacionaqui/app/utils/logger.dart';

class FollowerRepository {
  FollowerRepository();

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

    Future<List<Follower>> listFollowers(String parkingUID) async {
    try {
      final query =
          await CollectionsRef.parking
              .doc(parkingUID)
              .collection(Collections.follower)
              .get();

      return query.docs.map((doc) => Follower.fromJson(doc.data())).toList();
    } catch (e, s) {
      Logger.info('Erro em listByOwner: $e\n$s');
      return [];
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
