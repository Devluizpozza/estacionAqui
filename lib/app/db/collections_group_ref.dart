// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/models/follower.dart';

abstract class CollectionsGroupRef {
  static Query<Follower> get follower => DB.firestoreInstance
      .collectionGroup(Collections.follower)
      .withConverter<Follower>(
        fromFirestore: (snapshot, _) {
          return Follower.fromJson(snapshot.data()!);
        },
        toFirestore: (Follower scoreBySport, _) {
          return scoreBySport.toJson();
        },
      );
}
