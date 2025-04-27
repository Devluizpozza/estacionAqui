import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String name;
  final String contato;
  final String email;
  final String imageUrl;
  final DateTime createAt;

  const AppUser({
    required this.uid,
    required this.name,
    required this.contato,
    required this.email,
    this.imageUrl = '',
    required this.createAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      contato: map['contato'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createAt: (map['createAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'contato': contato,
      'email': email,
      'imageUrl': imageUrl,
      'createAt': createAt,
    };
  }

  factory AppUser.empty() {
    return AppUser(
      uid: '',
      name: '',
      contato: '',
      email: '',
      createAt: DateTime.now(),
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      contato: map['contato'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createAt:
          (map['createAt'] is Timestamp)
              ? (map['createAt'] as Timestamp).toDate()
              : DateTime.tryParse(map['createAt']?.toString() ?? '') ??
                  DateTime.now(),
    );
  }

  AppUser copyWith(Map<String, dynamic> newer) {
    Map<String, dynamic> current = toJson();
    Map<String, dynamic> merged = {...current, ...newer};
    return AppUser.fromJson(merged);
  }

  @override
  List<Object?> get props => [uid, name, contato, email, imageUrl, createAt];
}
