import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/collections_ref.dart';
import 'package:estacionaqui/app/models/vehicle_model.dart';
import 'package:estacionaqui/app/utils/logger.dart';

class VehicleRepository {
  VehicleRepository();

  Future<bool> create(String userUID, Vehicle vehicle) async {
    try {
      await CollectionsRef.appUser
          .doc(userUID)
          .collection(Collections.vehicle)
          .doc(vehicle.uid)
          .set(vehicle.toJson());

      return true;
    } catch (e) {
      Logger.info(e.toString());
      return false;
    }
  }

  Future<bool> remove(String vehicleUID, String userUID) async {
    try {
      await CollectionsRef.appUser
          .doc(userUID)
          .collection(Collections.vehicle)
          .doc(vehicleUID)
          .delete();
      return true;
    } catch (e) {
      Logger.info(e.toString());
      return false;
    }
  }

  Future<List<Vehicle>> list(String userUID) async {
    try {
      final query =
          await CollectionsRef.appUser
              .doc(userUID)
              .collection(Collections.vehicle)
              .get();

      return query.docs.map((doc) => Vehicle.fromJson(doc.data())).toList();
    } catch (e) {
      Logger.info(e.toString());
      return [];
    }
  }
}
