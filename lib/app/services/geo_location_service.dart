import 'package:estacionaqui/app/handlers/snack_bar_handler.dart';
import 'package:estacionaqui/app/models/geo_fire_point.dart';
import 'package:estacionaqui/app/models/geo_location_point.dart';
import 'package:estacionaqui/app/services/geo_location_place_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class GeolocationService extends GetxController {
  final Rx<PermissionStatus> _permissionStatus = Rx<PermissionStatus>(
    PermissionStatus.denied,
  );
  Rx<Position>? _position;
  final Rx<GeoFirePoint> _geoFirePoint = Rx<GeoFirePoint>(
    GeolocationPlacePoint.floripaGeoFirePoint,
  );

  @override
  void onInit() async {
    await status();
    super.onInit();
  }

  static GeolocationService get instance => Get.find<GeolocationService>();

  bool get granted => permissionStatus == PermissionStatus.granted;

  set permissionStatus(PermissionStatus value) {
    _permissionStatus.value = value;
    _permissionStatus.refresh();
  }

  PermissionStatus get permissionStatus => _permissionStatus.value;

  Position? get position => _position?.value;

  GeoFirePoint get geoFirePoint => _geoFirePoint.value;

  GeolocationPoint get geolocationPoint =>
      GeolocationPoint(geoFirePoint.latitude, geoFirePoint.longitude);

  set geoFirePoint(GeoFirePoint value) {
    _geoFirePoint.value = value;
    _geoFirePoint.refresh();
  }

  set position(Position? value) {
    _position = Rx<Position>(value!);
    _position!.refresh();
  }

  Future<PermissionStatus> status() async {
    try {
      permissionStatus = await Permission.location.status;
      return permissionStatus;
    } catch (e) {
      return permissionStatus;
    }
  }

  Future<PermissionStatus> requestPermission({bool showMessage = false}) async {
    try {
      permissionStatus = await status();
      if (!granted) {
        permissionStatus = await Permission.location.request();
      }
      if (!granted && showMessage) {
        SnackBarHandler.snackBarError('denied_location_permission_info'.tr);
      }
      return permissionStatus;
    } catch (e) {
      return permissionStatus;
    }
  }

  // void updatePlayerPlace(Place place) {
  //   try {
  //     UserRepository userRepository = UserRepository();
  //     userRepository.updatePlace(UserController.instance.user.uid, place).then((
  //       bool updated,
  //     ) {
  //       if (updated) {
  //         UserController.instance.fetch();
  //       }
  //     });
  //   } catch (e) {
  //     Logger.info(e);
  //   }
  // }

  // void checkPlayerLocation() async {
  //   try {
  //     if (granted) {
  //       // double movedKm = GeoFirePoint.kmDistanceBetween(
  //       //     from: UserController.instance.user.place.geolocationPoint.coords,
  //       //     to: geoFirePoint.coords);
  //       if (!UserController.instance.user.place.enabled &&
  //           NetworkConnectivity.instance.connected) {
  //         List<Place> places = await GeocodingAPIService.geocodeSearch(
  //           latlng: geolocationPoint.latLng.queryFormat,
  //           name: "address",
  //         );
  //         if (places.isNotEmpty) {
  //           updatePlayerPlace(places.first);
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     Logger.info(e);
  //   }
  // }

  // Future<GeoFirePoint> currentLocation() async {
  //   try {
  //     if (!granted) {
  //       await requestPermission();
  //     }

  //     position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.medium,
  //     );

  //     if (position != null) {
  //       geoFirePoint = GeoFirePoint(position!.latitude, position!.longitude);
  //       checkPlayerLocation();
  //     }
  //     return geoFirePoint;
  //   } catch (e) {
  //     Logger.info(e);
  //     return geoFirePoint;
  //   }
  // }

  // Future<GeoFirePoint> currentLocationFromSettings() async {
  //   try {
  //     bool useCurrentLocation =
  //         await GeolocationSettingsService.getUseCurrentLocation();

  //     if (useCurrentLocation) {
  //       return currentLocation();
  //     }

  //     return UserController.instance.player.place.geolocationPoint;
  //   } catch (e) {
  //     Logger.info(e);
  //     return geoFirePoint;
  //   }
  // }
}
