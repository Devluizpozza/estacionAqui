import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/models/app_user_model.dart';
import 'package:estacionaqui/app/models/parking_model.dart';

abstract class CollectionsRef {
  static CollectionReference get initialValue =>
      DB.firestoreInstance.collection(Collections.initial_value);

  static CollectionReference<AppUser> get appUser => DB.firestoreInstance
      .collection(Collections.app_user)
      .withConverter<AppUser>(
        fromFirestore: (snapshot, _) {
          return AppUser.fromJson(snapshot.data()!);
        },
        toFirestore: (AppUser appUser, _) {
          return appUser.toJson();
        },
      );

  static CollectionReference<Parking> get parking => DB.firestoreInstance
      .collection(Collections.parking)
      .withConverter<Parking>(
        fromFirestore: (snapshot, _) {
          return Parking.fromJson(snapshot.data()!);
        },
        toFirestore: (Parking parking, _) {
          return parking.toJson();
        },
      );
}
