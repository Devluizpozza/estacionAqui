import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/collections_group_ref.dart';
import 'package:estacionaqui/app/db/collections_ref.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/models/follower.dart';
import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/utils/logger.dart';

class ParkingRepository extends DB {
  ParkingRepository();

  Future<Parking> fetch(String uid) async {
    try {
      DocumentSnapshot<Parking> doc =
          await CollectionsRef.parking.doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        return Parking.empty();
      }

      return doc.data()!;
    } catch (e) {
      Logger.info(e);
      return Parking.empty();
    }
  }

  Future<bool> create(Parking parking) async {
    try {
      await CollectionsRef.parking.doc(parking.uid).set(parking);
      return true;
    } catch (e) {
      Logger.info(e);
      return false;
    }
  }

  Future<bool> updateOnly(String uid, Map<String, dynamic> changes) async {
    try {
      await CollectionsRef.parking.doc(uid).update(changes);
      return true;
    } catch (e) {
      Logger.info(e);
      return false;
    }
  }

  Future<bool> delete(String uid) async {
    try {
      await CollectionsRef.parking.doc(uid).delete();
      return true;
    } catch (e) {
      Logger.info(e);
      return false;
    }
  }

  Future<List<Parking>> list() async {
    try {
      final query = await CollectionsRef.parking.get();

      return query.docs.map((doc) => doc.data()).toList();
    } catch (e, s) {
      Logger.info('Erro em listByOwner: $e\n$s');
      return [];
    }
  }

  Future<List<Parking>> listByOwner(String ownerUID) async {
    try {
      final query =
          await CollectionsRef.parking
              .where("owner.uid", isEqualTo: ownerUID)
              .get();

      return query.docs.map((doc) => doc.data()).toList();
    } catch (e, s) {
      Logger.info('Erro em listByOwner: $e\n$s');
      return [];
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

  // Future<List<Parking>> sumFollowers(String ownerUID) async {
  //   try {
  //     final query =
  //         await CollectionsRef.parking
  //             .where("owner.uid", isEqualTo: ownerUID)
  //             .get();

  //     return query.docs.map((doc) => doc.data()).toList();
  //   } catch (e, s) {
  //     Logger.info('Erro em listByOwner: $e\n$s');
  //     return [];
  //   }
  // }

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
