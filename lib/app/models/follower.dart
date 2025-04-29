// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Follower extends Equatable {
  final String uid;
  final String userUID;
  final String userName;
  final DateTime createAt;

  const Follower({
    required this.uid,
    required this.userUID,
    required this.userName,

    required this.createAt,
  });

  factory Follower.fromJson(Map<String, dynamic> map) {
    return Follower(
      uid: map["uid"] ?? '',
      userUID: map['userUID'] ?? '',
      userName: map['userName'] ?? '',
      createAt:
          map['createAt'] is Timestamp
              ? (map['createAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createAt']?.toString() ?? '') ??
                  DateTime.now(),
    );
  }
  factory Follower.fromRealtimeJson(Map<String, dynamic> map) {
    return Follower(
      uid: map["uid"] ?? '',
      userUID: map['userUID'] ?? '',
      userName: map['userName'] ?? '',

      createAt: (map['createAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userUID': userUID,
      'userName': userName,
      'createAt': createAt,
    };
  }

  factory Follower.empty() {
    return Follower(
      uid: '',
      userUID: '',
      userName: '',
      createAt: DateTime.now(),
    );
  }

  Follower copyWith(Map<String, dynamic> newer) {
    Map<String, dynamic> current = toJson();
    Map<String, dynamic> merged = {...current, ...newer};
    return Follower.fromJson(merged);
  }

  @override
  List<Object?> get props => [uid, userUID, userName, createAt];
}
