// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:estacionaqui/app/models/geo_fire_point_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocationPoint extends GeoFirePoint with EquatableMixin {
  GeolocationPoint(super.latitude, super.longitude);

  GeoFirePoint get geoFirePoint => GeoFirePoint(latitude, longitude);

  LatLng get latLng => LatLng(latitude, longitude);

  Map<String, dynamic> get realtimeData => {
    "geopoint": {"latitude": latitude, "longitude": longitude},
  };

  factory GeolocationPoint.empty() {
    return GeolocationPoint(0.0, 0.0);
  }

  factory GeolocationPoint.fromGeoFirePoint(GeoFirePoint geoFirePoint) {
    return GeolocationPoint(geoFirePoint.latitude, geoFirePoint.longitude);
  }

  factory GeolocationPoint.fromJson(Map<String, dynamic> map) {
    if (map['geopoint'] != null) {
      return GeolocationPoint(
        map['geopoint'].latitude,
        map['geopoint'].longitude,
      );
    }
    return GeolocationPoint.empty();
  }

  factory GeolocationPoint.fromRealtimeJson(Map<String, dynamic> map) {
    if (map['geopoint'] != null &&
        map['geopoint']["latitude"] != null &&
        map['geopoint']["longitude"] != null) {
      return GeolocationPoint(
        map['geopoint']["latitude"],
        map['geopoint']["longitude"],
      );
    }
    return GeolocationPoint.empty();
  }

  @override
  List<Object?> get props => [latitude, longitude, hash];
}
