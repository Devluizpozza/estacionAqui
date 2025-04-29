// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:estacionaqui/app/models/app_user_model.dart';
import 'package:estacionaqui/app/models/place_model.dart';
import 'package:estacionaqui/app/models/place_short_model.dart';
import 'package:estacionaqui/app/models/ticket_model.dart';

class Parking extends Equatable {
  final String uid;
  final AppUser owner;
  final String displayName;
  final String description;
  final String phone;
  final int slots;
  final double carValue;
  final double motoValue;
  final List<String> comforts;
  final List<Ticket>? tickets;
  final PlaceShort place;
  final DateTime createAt;

  const Parking({
    required this.uid,
    required this.owner,
    required this.displayName,
    required this.description,
    required this.phone,
    required this.slots,
    required this.carValue,
    required this.motoValue,
    required this.comforts,
    this.tickets = const <Ticket>[],
    required this.place,
    required this.createAt,
  });

  factory Parking.fromJson(Map<String, dynamic> map) {
    return Parking(
      uid: map["uid"] ?? '',
      owner:
          map['owner'] is Map<String, dynamic>
              ? AppUser.fromMap(map['owner'])
              : AppUser.empty(),
      displayName: map['displayName'] ?? '',
      description: map['description'] ?? '',
      phone: map['phone'] ?? '',
      slots: map['slots'] ?? 10,
      carValue: map['carValue'] ?? 0.0,
      motoValue: map['motoValue'] ?? 0.0,
      comforts: List<String>.from(map['comforts'] ?? []),
      tickets: List<Ticket>.from(map['tickets'] ?? []),
      place:
          map['place'] is Map<String, dynamic>
              ? PlaceShort.fromMap(map['place'])
              : PlaceShort.empty(),
      createAt:
          map['createAt'] is Timestamp
              ? (map['createAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createAt']?.toString() ?? '') ??
                  DateTime.now(),
    );
  }
  factory Parking.fromRealtimeJson(Map<String, dynamic> map) {
    return Parking(
      uid: map["uid"] ?? '',
      owner: map['owner'] ?? AppUser.empty(),
      displayName: map['displayName'] ?? '',
      description: map['description'] ?? '',
      phone: map['phone'] ?? 0.0,
      slots: map['slots'] ?? 0,
      carValue: map['carValue'] ?? 0.0,
      motoValue: map['motoValue'] ?? 0.0,
      comforts: map['comforts'] ?? [],
      tickets: map['tickets'] ?? [],
      place: map['place'] ?? Place.empty(),
      createAt: (map['createAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'owner': owner.toJson(),
      'displayName': displayName,
      'description': description,
      'phone': phone,
      'slots': slots,
      'carValue': carValue,
      'motoValue': motoValue,
      'comforts': comforts,
      'tickets': tickets,
      'place': place.toJson(),
      'createAt': createAt,
    };
  }

  factory Parking.empty() {
    return Parking(
      uid: '',
      owner: AppUser.empty(),
      displayName: '',
      description: '',
      phone: '',
      slots: 0,
      carValue: 0.0,
      motoValue: 0.0,
      comforts: [],
      tickets: [],
      place: PlaceShort.empty(),
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
    owner,
    displayName,
    description,
    phone,
    slots,
    carValue,
    motoValue,
    comforts,
    tickets,
    place,
    createAt,
  ];
}
