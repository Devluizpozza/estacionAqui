// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';
import 'package:estacionaqui/app/models/geo_fire_point_model.dart';
import 'package:estacionaqui/app/models/geo_location_point_model.dart';
import 'package:estacionaqui/app/models/place_short_model.dart';
import 'package:estacionaqui/app/services/geo_location_service.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:latlong2/latlong.dart';

class Place extends Equatable {
  String uid;
  String placeId;
  String name;
  String fullAddress;
  String street;
  String city;
  String fu;
  String country;
  String countryCode;
  String postalCode;
  String number;
  String neighborhood;
  final GeolocationPoint geolocationPoint;
  bool enabled;
  String complement;

  Place({
    this.uid = '',
    this.placeId = '',
    this.name = '',
    this.fullAddress = '',
    this.street = '',
    this.city = '',
    this.fu = '',
    this.country = '',
    this.countryCode = '',
    this.postalCode = '',
    this.number = '',
    this.neighborhood = '',
    required this.geolocationPoint,
    this.enabled = false,
    this.complement = '',
  }) {
    if (city.isEmpty) {
      populateFields();
    }
  }

  double distanceBetween(GeoFirePoint startGeoPoint) {
    return GeoFirePoint.kmDistanceBetween(
      to: startGeoPoint.coords,
      from: geolocationPoint.coords,
    );
  }

  LatLng get latLng => geolocationPoint.latLng;

  String get cityFull {
    String cityTmp = "";
    if (city.isNotEmpty) {
      cityTmp = city;
    }
    if (cityTmp.isNotEmpty && fu.isNotEmpty) {
      cityTmp = '$cityTmp - $fu';
    }
    if (cityTmp.isEmpty) {
      return fullAddress;
    }
    return cityTmp;
  }

  bool get isEmpty => cityFull.isEmpty;

  PlaceShort get short => PlaceShort(
    placeId: placeId,
    fullAddress: fullAddress,
    city: city,
    countryCode: countryCode,
    fu: fu,
    geolocationPoint: geolocationPoint,
  );

  void populateFields() {
    List<String> addrs = fullAddress.split(",");
    try {
      if (addrs.length >= 3) {
        if (addrs[addrs.length - 3].contains("-")) {
          List<String> cityArr = addrs[addrs.length - 3].split('-');
          country = addrs[addrs.length - 1].trim();
          postalCode = addrs[addrs.length - 2].trim();
          city = cityArr[0].trim();
          fu = cityArr[1].trim();
        } else {
          city = addrs[addrs.length - 3].trim();
          fu = addrs[addrs.length - 2].trim();
          country = addrs[addrs.length - 1].trim();
        }
      }
    } catch (e) {
      Logger.info(e);
    }
  }

  static Map<String, dynamic> parseFromFormattedAddress(
    Map<String, dynamic> map,
  ) {
    String country = "";
    String postalCode = "";
    String city = "";
    String fu = "";
    String number = "";
    String street = "";
    String neighborhood = "";
    String countryCode = "";
    try {
      if (map.containsKey("formatted_address")) {
        List<String> addrs = map["formatted_address"].split(",");
        if (addrs.length >= 3) {
          List<String> cityArr = addrs[addrs.length - 3].split('-');
          country = addrs[addrs.length - 1].trim();
          postalCode = addrs[addrs.length - 2].trim();
          city = cityArr[0].trim();
          fu = cityArr[1].trim();
        }
      }
      return {
        "street": street,
        "city": city,
        "country": country,
        "countryCode": countryCode,
        "fu": fu,
        "postalCode": postalCode,
        "number": number,
        "neighborhood": neighborhood,
        "complement": "",
      };
    } catch (e) {
      return {
        "street": street,
        "city": city,
        "country": country,
        "countryCode": countryCode,
        "fu": fu,
        "postalCode": postalCode,
        "number": number,
        "neighborhood": neighborhood,
        "complement": "",
      };
    }
  }

  static Map<String, dynamic> parseAddressComponent(
    Map<String, dynamic> map, {
    bool isFromGeocode = false,
  }) {
    try {
      if (map["address_components"] is List<Map<String, dynamic>>) {
        return Place.fromAddressComponents(
          map["address_components"],
          isFromGeocode: isFromGeocode,
        );
      }
      return Place.fromAddressComponents(
        List<Map<String, dynamic>>.from(map["address_components"]),
        isFromGeocode: isFromGeocode,
      );
    } catch (e) {
      Logger.info(e);
      return {
        "street": "",
        "city": "",
        "country": "",
        "countryCode": "",
        "fu": "",
        "postalCode": "",
        "number": "",
        "neighborhood": "",
        "complement": "",
      };
    }
  }

  factory Place.empty() {
    return Place(
      geolocationPoint: GeolocationService.instance.geolocationPoint,
    );
  }

  factory Place.fromGoogleMapsJson(
    Map<String, dynamic> map, {
    String name = '',
    String complement = '',
    bool isFromGeocode = false,
  }) {
    Map<String, dynamic> addressComponentsMap = {};
    if (map.containsKey("address_components")) {
      addressComponentsMap = Place.parseAddressComponent(
        map,
        isFromGeocode: isFromGeocode,
      );
    } else {
      addressComponentsMap = Place.parseFromFormattedAddress(map);
    }

    return Place(
      uid: map["uid"] ?? '',
      placeId: map["place_id"],
      name: map["name"] ?? name,
      geolocationPoint: GeolocationPoint.fromGeoFirePoint(
        Place.geometryToGeoFirePoint(map["geometry"]),
      ),
      fullAddress: map["formatted_address"],
      street: addressComponentsMap["street"],
      city: addressComponentsMap["city"] ?? '',
      country: addressComponentsMap["country"] ?? '',
      countryCode: addressComponentsMap["countryCode"] ?? '',
      fu: addressComponentsMap["fu"] ?? '',
      postalCode: addressComponentsMap["postalCode"] ?? '',
      number: addressComponentsMap["number"] ?? '',
      neighborhood: addressComponentsMap["neighborhood"] ?? '',
      enabled: true,
      complement: complement,
    );
  }

  factory Place.fromJson(Map<String, dynamic> map) {
    return Place(
      uid: map["uid"] ?? '',
      placeId: map['placeId'] ?? '',
      name: map['name'] ?? '',
      fullAddress: map['fullAddress'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      fu: map['fu'] ?? '',
      country: map['country'] ?? '',
      countryCode: map['countryCode'] ?? '',
      postalCode: map['postalCode'] ?? '',
      number: map['number'] ?? '',
      neighborhood: map['neighborhood'] ?? '',
      geolocationPoint:
          map["geolocationPoint"] != null
              ? GeolocationPoint.fromJson(map["geolocationPoint"])
              : GeolocationPoint.empty(),
      enabled: map['enabled'] ?? false,
      complement: map['complement'] ?? '',
    );
  }

  factory Place.fromRealtimeJson(Map<String, dynamic> map) {
    return Place(
      uid: map["uid"] ?? '',
      placeId: map['placeId'],
      name: map['name'],
      street: map['street'] ?? '',
      fullAddress: map['fullAddress'] ?? '',
      city: map['city'] ?? '',
      fu: map['fu'] ?? '',
      country: map['country'] ?? '',
      countryCode: map['countryCode'] ?? '',
      postalCode: map['postalCode'] ?? '',
      number: map['number'] ?? '',
      neighborhood: map['neighborhood'] ?? '',
      geolocationPoint: GeolocationPoint.fromRealtimeJson(map),
      enabled: map['enabled'] ?? false,
      complement: map['complement'] ?? '',
    );
  }

  Map<String, dynamic> toJson({bool fromLocalGeolocationPoint = false}) {
    return {
      'uid': uid,
      'placeId': placeId,
      'name': name,
      'fullAddress': fullAddress,
      'street': street,
      'city': city,
      'fu': fu,
      'country': country,
      'countryCode': countryCode,
      'postalCode': postalCode,
      'cityText': city.toLowerCase(),
      'number': number,
      'neighborhood': neighborhood,
      'geolocationPoint':
          fromLocalGeolocationPoint
              ? GeolocationService.instance.geolocationPoint.realtimeData
              : geolocationPoint.data,
      'enabled': enabled,
      'complement': complement,
    };
  }

  Map<String, dynamic> toJsonFunctions() {
    return {
      'uid': uid,
      'placeId': placeId,
      'name': name,
      'fullAddress': fullAddress,
      'street': street,
      'city': city,
      'fu': fu,
      'country': country,
      'countryCode': countryCode,
      'postalCode': postalCode,
      'cityText': city.toLowerCase(),
      'number': number,
      'neighborhood': neighborhood,
      'enabled': enabled,
      'complement': complement,
    };
  }

  static GeoFirePoint geometryToGeoFirePoint(Map<String, dynamic> map) {
    Map<String, dynamic> location = map["location"];
    return GeoFirePoint(4.0, 5.0);
    // Geoflutterfire()
    //     .point(latitude: location["lat"], longitude: location["lng"]);
  }

  static Map<String, dynamic> fromAddressComponents(
    List<Map<String, dynamic>>? list, {
    bool isFromGeocode = false,
  }) {
    try {
      if (list == null && list!.isEmpty) {
        return {
          "street": "",
          "city": "",
          "country": "",
          "countryCode": "",
          "fu": "",
          "postalCode": "",
          "number": '',
          "neighborhood": "",
          "complement": "",
        };
      }
      List<Map<String, dynamic>> reversed = list.reversed.toList();

      if (isFromGeocode) {
        String countryRaw = reversed[1]["long_name"] ?? '';
        String countryCodeRaw = reversed[1]["short_name"] ?? '';
        String fuRaw = reversed[2]["short_name"] ?? '';
        String cityRaw = reversed[3]["long_name"] ?? '';
        String neighborhoodRaw = reversed[4]["long_name"] ?? '';
        String streetRaw = reversed[5]["long_name"] ?? '';
        String postalCodeRaw = reversed[0]["long_name"] ?? '';

        return {
          "number": '',
          "street": streetRaw,
          "neighborhood": neighborhoodRaw,
          "city": cityRaw,
          "fu": fuRaw,
          "country": countryRaw,
          "countryCode": countryCodeRaw,
          "postalCode": postalCodeRaw,
        };
      }
      String postalCodeRaw = reversed[0]["long_name"] ?? '';
      String countryRaw = reversed[1]["long_name"] ?? '';
      String countryCodeRaw = reversed[1]["short_name"] ?? '';
      String fuRaw = reversed[2]["short_name"] ?? '';
      String cityRaw = reversed[3]["long_name"] ?? '';
      String neighborhoodRaw = reversed[4]["long_name"] ?? '';
      String streetRaw = reversed[5]["long_name"] ?? '';
      String numberRaw = reversed[6]["long_name"] ?? '';

      if (reversed.length > 7) {
        String numberAdditional = reversed[7]["long_name"];
        numberRaw = '$numberRaw - $numberAdditional';
      }

      return {
        "number": numberRaw,
        "street": streetRaw,
        "neighborhood": neighborhoodRaw,
        "city": cityRaw,
        "fu": fuRaw,
        "country": countryRaw,
        "countryCode": countryCodeRaw,
        "postalCode": postalCodeRaw,
      };
    } catch (e) {
      return {
        "street": "",
        "city": "",
        "country": "",
        "countryCode": "",
        "fu": "",
        "postalCode": "",
        "number": '',
        "neighborhood": "",
        "complement": "",
      };
    }
  }

  // Map<String, dynamic> toJsonForUser() {
  //   return {
  //     ...toJson(),
  //     'geolocationPoint': GeolocationService.instance.geolocationPoint,
  //   };
  // }

  Map<String, dynamic> toRealtimeJson() {
    return {...toJson(), 'geolocationPoint': geolocationPoint.realtimeData};
  }

  Place copyWith(Map<String, dynamic> newer) {
    Map<String, dynamic> current = toJson();
    Map<String, dynamic> merged = {...current, ...newer};
    return Place.fromJson(merged);
  }

  @override
  List<Object?> get props => [
    uid,
    placeId,
    name,
    fullAddress,
    street,
    city,
    fu,
    country,
    countryCode,
    postalCode,
    number,
    neighborhood,
    geolocationPoint,
    enabled,
    complement,
  ];
}
