// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/models/follower.dart';
import 'package:estacionaqui/app/models/ticket_model.dart';

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

  static Query<Ticket> get ticket => DB.firestoreInstance
      .collectionGroup(Collections.ticket)
      .withConverter<Ticket>(
        fromFirestore: (snapshot, _) {
          return Ticket.fromJson(snapshot.data()!);
        },
        toFirestore: (Ticket scoreBySport, _) {
          return scoreBySport.toJson();
        },
      );
}
