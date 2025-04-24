// ignore_for_file: must_be_immutable

import 'package:estacionaqui/app/models/geo_location_point_model.dart';
import 'package:estacionaqui/app/models/place_model.dart';
import 'package:estacionaqui/app/services/geo_location_service.dart';

class PlaceShort extends Place {
  PlaceShort({
    super.placeId = '',
    super.fullAddress = '',
    super.city = '',
    super.fu = '',
    super.countryCode = '',
    required super.geolocationPoint,
  });

  factory PlaceShort.empty() {
    return PlaceShort(
      geolocationPoint: GeolocationService.instance.geolocationPoint,
    );
  }

  factory PlaceShort.fromJson(Map<String, dynamic> map, {bool isRDB = false}) {
    return PlaceShort(
      placeId: map['placeId'] ?? '',
      fullAddress: map['fullAddress'] ?? '',
      city: map['city'] ?? '',
      fu: map['fu'] ?? '',
      countryCode: map['countryCode'] ?? '',
      geolocationPoint: GeolocationPoint.fromJson(map["geolocationPoint"]),
    );
  }

  factory PlaceShort.fromRealtimeJson(Map<String, dynamic> map) {
    return PlaceShort(
      placeId: map['placeId'] ?? '',
      fullAddress: map['fullAddress'] ?? '',
      city: map['city'] ?? '',
      fu: map['fu'] ?? '',
      countryCode: map['countryCode'] ?? '',
      geolocationPoint: GeolocationPoint.fromRealtimeJson(map),
    );
  }

  @override
  Map<String, dynamic> toJson({bool fromLocalGeolocationPoint = false}) {
    return {
      'placeId': placeId,
      'fullAddress': fullAddress,
      'city': city,
      'fu': fu,
      'countryCode': countryCode,
      'geolocationPoint':
          fromLocalGeolocationPoint
              ? GeolocationService.instance.geolocationPoint.data
              : geolocationPoint.data,
    };
  }

  @override
  PlaceShort copyWith(Map<String, dynamic> newer) {
    Map<String, dynamic> current = toJson();
    Map<String, dynamic> merged = {...current, ...newer};
    return PlaceShort.fromJson(merged);
  }

  @override
  List<Object?> get props => [
    placeId,
    fullAddress,
    city,
    fu,
    countryCode,
    geolocationPoint,
  ];
}
