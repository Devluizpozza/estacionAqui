import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:estacionaqui/app/models/geo_fire_point_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
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

  /// Usado quando o Firebase retorna um GeoPoint diretamente
  factory GeolocationPoint.fromMap(Map<String, dynamic> map) {
    final geoPoint = map['geopoint'];
    if (geoPoint is GeoPoint) {
      return GeolocationPoint(geoPoint.latitude, geoPoint.longitude);
    } else if (geoPoint is Map<String, dynamic>) {
      return GeolocationPoint(
        geoPoint['latitude'] ?? 0.0,
        geoPoint['longitude'] ?? 0.0,
      );
    }
    return GeolocationPoint.empty();
  }

  /// Usado em dados do Realtime Database (mapa aninhado)
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

  factory GeolocationPoint.fromJson(Map<String, dynamic> map) {
    if (map['geopoint'] != null) {
      return GeolocationPoint(
        map['geopoint'].latitude,
        map['geopoint'].longitude,
      );
    }
    return GeolocationPoint.empty();
  }

  /// Para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {'geopoint': GeoPoint(latitude, longitude)};
  }

  @override
  List<Object?> get props => [latitude, longitude, hash];
}
