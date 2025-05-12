// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/models/vehicle_model.dart';

class Ticket extends Equatable {
  final String uid;
  final double value;
  final String description;
  final String payerUID;
  final String parkingUID;
  final VehicleType vehicleType;
  final Vehicle vehicle;
  final StatusType statusType;
  final bool payed;
  final DateTime createAt;

  const Ticket({
    required this.uid,
    required this.value,
    required this.description,
    required this.payerUID,
    required this.parkingUID,
    required this.vehicleType,
    required this.vehicle,
    required this.createAt,
    this.statusType = StatusType.none,
    this.payed = false,
  });

  String get vtype => vehicleType.name;
  String get stype => statusType.name;
  bool get parked => statusType == StatusType.active;

  factory Ticket.fromJson(Map<String, dynamic> map) {
    return Ticket(
      uid: map["uid"] ?? '',
      value: (map['value'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      payerUID: map['payerUID'] ?? '',
      parkingUID: map['parkingUID'] ?? '',
      vehicleType: VehicleType.values.firstWhere(
        (vehicleType) => vehicleType.name == map['vehicleType'],
        orElse: () => VehicleType.none,
      ),
      vehicle:
          map['vehicle'] is Map<String, dynamic>
              ? Vehicle.fromJson(map['vehicle'])
              : Vehicle.empty(),
      statusType: StatusType.values.firstWhere(
        (statusType) => statusType.name == map['statusType'],
        orElse: () => StatusType.none,
      ),
      payed: map['payed'] ?? false,
      createAt:
          map['createAt'] is Timestamp
              ? (map['createAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createAt']?.toString() ?? '') ??
                  DateTime.now(),
    );
  }

  factory Ticket.fromRealtimeJson(Map<String, dynamic> map) {
    return Ticket.fromJson(map);
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket.fromJson(map);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'value': value,
      'description': description,
      'payerUID': payerUID,
      'parkingUID': parkingUID,
      'vehicleType': vtype,
      'vehicle': vehicle.toJson(),
      'statusType': stype,
      'payed': payed,
      'createAt': createAt,
    };
  }

  factory Ticket.empty() {
    return Ticket(
      uid: '',
      value: 0.0,
      description: '',
      payerUID: '',
      parkingUID: '',
      vehicleType: VehicleType.none,
      vehicle: Vehicle.empty(),
      statusType: StatusType.none,
      payed: false,
      createAt: DateTime.now(),
    );
  }

  Ticket copyWith(Map<String, dynamic> newer) {
    Map<String, dynamic> current = toJson();
    Map<String, dynamic> merged = {...current, ...newer};
    return Ticket.fromJson(merged);
  }

  @override
  List<Object?> get props => [
    uid,
    value,
    description,
    payerUID,
    parkingUID,
    vehicleType,
    vehicle,
    statusType,
    payed,
    createAt,
  ];
}
