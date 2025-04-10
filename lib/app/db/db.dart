import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionaqui/app/services/network_conectivity.dart';

class DB {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  static String generateId({
    String prefix = '',
    int length = 28,
    String separator = "_",
  }) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    String autoId = '';
    while (autoId.length < length) {
      List<int> bytes = List<int>.generate(
        40,
        (i) => Random.secure().nextInt(256),
      );
      for (var b in bytes) {
        const maxValue = 62 * 4 - 1;
        if (autoId.length < length && b <= maxValue) {
          autoId += String.fromCharCode(chars.codeUnitAt(b % 62));
        }
      }
    }
    return prefix.isEmpty ? autoId : '$prefix$separator$autoId';
  }

  static String generateUID(String collectionName, {bool group = false}) {
    try {
      return firestoreInstance.collection(collectionName).doc().id;
    } catch (e) {
      return DB.generateId();
    }
  }

  static int get timeout =>
      NetworkConnectivity.instance.connected ? 10000 : 3000;

  static Duration get timeoutDuration => Duration(milliseconds: DB.timeout);
}
