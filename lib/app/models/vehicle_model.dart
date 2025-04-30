// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:estacionaqui/app/consts/enums.dart';

class Vehicle extends Equatable {
  final String uid;
  final String plate;
  final String userUID;
  final String vehicleColor;
  final VehicleType vehicleType;
  final CarMarkType? carMarkType;
  final MotoMarkType? motoMarkType;
  final DateTime createAt;

  const Vehicle({
    this.carMarkType = CarMarkType.none,
    this.motoMarkType = MotoMarkType.none,
    required this.uid,
    required this.vehicleType,
    required this.createAt,
    required this.plate,
    required this.userUID,
    required this.vehicleColor,
  });

  String get vtype => vehicleType.name.toString();

  String? get ctype => carMarkType?.name.toString();

  String? get mtype => motoMarkType?.name.toString();

  factory Vehicle.fromJson(Map<String, dynamic> map) {
    return Vehicle(
      uid: map["uid"] ?? '',
      plate: map['plate'] ?? 0.0,
      userUID: map['userUID'] ?? '',
      vehicleColor: map['vehicleColor'] ?? '',
      vehicleType: VehicleType.values.firstWhere(
        (VehicleType vehicleType) => vehicleType.name == map['vehicleType'],
      ),
      carMarkType: CarMarkType.values.firstWhere(
        (CarMarkType carMarkType) => carMarkType.name == map['carMarkType'],
      ),
      motoMarkType: MotoMarkType.values.firstWhere(
        (MotoMarkType motoMarkType) => motoMarkType.name == map['motoMarkType'],
      ),
      createAt:
          map['createAt'] is Timestamp
              ? (map['createAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createAt']?.toString() ?? '') ??
                  DateTime.now(),
    );
  }
  factory Vehicle.fromRealtimeJson(Map<String, dynamic> map) {
    return Vehicle(
      uid: map["uid"] ?? '',
      plate: map['plate'] ?? 0.0,
      userUID: map['userUID'] ?? '',
      vehicleColor: map['vehicleColor'] ?? '',
      vehicleType: VehicleType.values.firstWhere(
        (VehicleType vehicleType) => vehicleType.name == map['vehicleType'],
      ),
      carMarkType: CarMarkType.values.firstWhere(
        (CarMarkType carMarkType) => carMarkType.name == map['carMarkType'],
      ),
      motoMarkType: MotoMarkType.values.firstWhere(
        (MotoMarkType motoMarkType) => motoMarkType.name == map['motoMarkType'],
      ),
      createAt:
          map['createAt'] is Timestamp
              ? (map['createAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createAt']?.toString() ?? '') ??
                  DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'plate': plate,
      'userUID': userUID,
      'vehicleColor': vehicleColor,
      'vehicleType': vtype,
      'carMarkType': ctype,
      'motoMarkType': mtype,
      'createAt': createAt,
    };
  }

  factory Vehicle.empty() {
    return Vehicle(
      uid: '',
      plate: '',
      userUID: '',
      vehicleColor: '',
      vehicleType: VehicleType.car,
      carMarkType: CarMarkType.none,
      motoMarkType: MotoMarkType.none,
      createAt: DateTime.now(),
    );
  }

  Vehicle copyWith(Map<String, dynamic> newer) {
    Map<String, dynamic> current = toJson();
    Map<String, dynamic> merged = {...current, ...newer};
    return Vehicle.fromJson(merged);
  }

  @override
  List<Object?> get props => [
    uid,
    plate,
    userUID,
    vehicleType,
    carMarkType,
    motoMarkType,
    createAt,
  ];
}
