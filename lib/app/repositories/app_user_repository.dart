import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estacionaqui/app/db/collections_ref.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/models/app_user_model.dart';
import 'package:estacionaqui/app/utils/logger.dart';

class AppUserRepository extends DB {
  AppUserRepository();
  //fetch padrao
  // Future<AppUser> fetch(String uid) async {
  //   try {
  //     DocumentSnapshot<AppUser> doc =
  //         await CollectionsRef.appUser.doc(uid).get();
  //     AppUser? data = doc.data();
  //     return data!;
  //   } catch (e) {
  //     Logger.info(e);
  //     return Future.error(e.toString());
  //   }
  // }

  //fetch retornando usuário.empty caso ele nao exista(primeiro login);
  Future<AppUser> fetch(String uid) async {
    try {
      DocumentSnapshot<AppUser> doc =
          await CollectionsRef.appUser.doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        return AppUser.empty();
      }

      return doc.data()!;
    } catch (e) {
      Logger.info(e);
      return Future.error("Erro ao buscar usuário: $e");
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

  Future<bool> updateOnly(String uid, Map<String, dynamic> changes) async {
    try {
      await CollectionsRef.appUser.doc(uid).update(changes);
      return true;
    } catch (e) {
      Logger.info(e);
      return false;
    }
  }
}
