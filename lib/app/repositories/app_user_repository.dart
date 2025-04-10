import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionaqui/app/db/collections_ref.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/models/user_model.dart';
import 'package:estacionaqui/app/utils/logger.dart';

class AppUserRepository extends DB {
  AppUserRepository();

  Future<AppUser> fetch(String uid) async {
    try {
      DocumentSnapshot<AppUser> doc =
          await CollectionsRef.appUser.doc(uid).get();
      AppUser? data = doc.data();
      return data!;
    } catch (e) {
      Logger.info(e);
      return Future.error(e.toString());
    }
  }

  Future<bool> create(AppUser appUser) async {
    try {
      await CollectionsRef.appUser.doc(appUser.uid).set(appUser);
      return true;
    } catch (e) {
      Logger.info(e);
      return false;
    }
  }
}
