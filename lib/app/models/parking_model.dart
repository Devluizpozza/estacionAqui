// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:estacionaqui/app/models/place_model.dart';

class Parking extends Equatable {
  final String uid;
  final String displayName;
  final String description;
  final String phone;
  final int slots;
  final List<String> conforts;
  final Place? place;
  final DateTime createAt;

  const Parking({
    required this.uid,
    required this.displayName,
    required this.description,
    required this.phone,
    required this.slots,
    required this.conforts,
    this.place,
    required this.createAt,
  });

  factory Parking.fromJson(Map<String, dynamic> map) {
    return Parking(
      uid: map["uid"] ?? '',
      displayName: map['displayName'] ?? '',
      description: map['description'] ?? '',
      phone: map['phone'] ?? '',
      slots: map['slots'] ?? 10,
      conforts: map['conforts'] ?? [],
      place: map['place'] ?? Place.empty(),
      createAt: (map['createAt'] as Timestamp).toDate(),
    );
  }

  factory Parking.fromRealtimeJson(Map<String, dynamic> map) {
    return Parking(
      uid: map["uid"] ?? '',
      displayName: map['displayName'] ?? '',
      description: map['description'] ?? '',
      phone: map['phone'] ?? '',
      slots: map['slots'] ?? 10,
      conforts: map['conforts'] ?? [],
      place: map['place'] ?? Place.empty(),
      createAt: (map['createAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson({bool fromLocalGeolocationPoint = false}) {
    return {
      'uid': uid,
      'displayName': displayName,
      'description': description,
      'phone': phone,
      'slots': slots,
      'conforts': conforts,
      'place': place,
      'createAt': createAt,
    };
  }

  factory Parking.empty() {
    return Parking(
      uid: '',
      displayName: '',
      description: '',
      phone: '',
      slots: 10,
      conforts: [],
      place: Place.empty(),
      createAt: DateTime.now(),
    );
  }

  Parking copyWith(Map<String, dynamic> newer) {
    Map<String, dynamic> current = toJson();
    Map<String, dynamic> merged = {...current, ...newer};
    return Parking.fromJson(merged);
  }

  @override
  List<Object?> get props => [
    uid,
    displayName,
    description,
    phone,
    slots,
    conforts,
    place,
    createAt,
  ];
}
