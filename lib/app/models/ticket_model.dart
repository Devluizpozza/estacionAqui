// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:estacionaqui/app/consts/enums.dart';

class Ticket extends Equatable {
  final String uid;
  final double value;
  final String description;
  final String payerUID;
  final String parkingUID;
  final VehicleType vehicleType;
  final DateTime createAt;

  const Ticket({
    required this.uid,
    required this.value,
    required this.description,
    required this.payerUID,
    required this.parkingUID,
    required this.vehicleType,
    required this.createAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> map) {
    return Ticket(
      uid: map["uid"] ?? '',
      value: map['value'] ?? 0.0,
      description: map['description'] ?? '',
      payerUID: map['payerUID'] ?? '',
      parkingUID: map['parkingUID'] ?? '',
      vehicleType: VehicleType.values.firstWhere(
        (VehicleType vehicleType) => vehicleType.name == map['vehicleType'],
      ),
      createAt:
          map['createAt'] is Timestamp
              ? (map['createAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createAt']?.toString() ?? '') ??
                  DateTime.now(),
    );
  }
  factory Ticket.fromRealtimeJson(Map<String, dynamic> map) {
    return Ticket(
      uid: map["uid"] ?? '',
      value: map['value'] ?? 0.0,
      description: map['description'] ?? '',
      payerUID: map['payerUID'] ?? '',
      parkingUID: map['parkingUID'] ?? '',
      vehicleType: VehicleType.values.firstWhere(
        (VehicleType vehicleType) => vehicleType.name == map['vehicleType'],
      ),
      createAt: (map['createAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'value': value,
      'description': description,
      'payerUID': payerUID,
      'parkingUID': parkingUID,
      'vehicleType': vehicleType,
      'createAt': createAt,
    };
  }

  factory Ticket.empty() {
    return Ticket(
      uid: '',
      value: 0,
      description: '',
      payerUID: '',
      parkingUID: '',
      vehicleType: VehicleType.car,
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
    createAt,
  ];
}
