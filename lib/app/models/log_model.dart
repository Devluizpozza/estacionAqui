// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:estacionaqui/app/consts/enums.dart';

class Log extends Equatable {
  final String uid;
  final String userUID;
  final ActionType actionType;
  final String? targetId;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const Log({
    required this.uid,
    required this.userUID,
    required this.actionType,
    this.targetId,
    this.metadata,
    required this.createdAt,
  });

  String get atype => actionType.name;

  factory Log.fromJson(Map<String, dynamic> map) {
    return Log(
      uid: map["uid"] ?? '',
      userUID: map['userUID'] ?? '',
      actionType: ActionType.values.firstWhere(
        (actionType) => actionType.name == map['actionType'],
        orElse: () => ActionType.none,
      ),
      targetId: map['targetId'],
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
      createdAt:
          map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
                  DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userUID': userUID,
      'actionType': atype,
      'targetId': targetId,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Log.empty() {
    return Log(
      uid: '',
      userUID: '',
      actionType: ActionType.none,
      targetId: null,
      metadata: {},
      createdAt: DateTime.now(),
    );
  }

  Log copyWith(Map<String, dynamic> newer) {
    Map<String, dynamic> current = toJson();
    Map<String, dynamic> merged = {...current, ...newer};
    return Log.fromJson(merged);
  }

  @override
  List<Object?> get props => [
    uid,
    userUID,
    actionType,
    targetId,
    metadata,
    createdAt,
  ];
}
