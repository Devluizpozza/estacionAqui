import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String name;
  final String placa;
  final String contato;
  final String email;

  const AppUser({
    required this.uid,
    required this.name,
    required this.placa,
    required this.contato,
    required this.email,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      placa: json['placa'] ?? '',
      contato: json['contato'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'placa': placa,
      'contato': contato,
      'email': email,
    };
  }

  factory AppUser.empty() {
    return const AppUser(uid: '', name: '', placa: '', contato: '', email: '');
  }

  AppUser copyWith(Map<String, dynamic> newer) {
    Map<String, dynamic> current = toJson();
    Map<String, dynamic> merged = {...current, ...newer};
    return AppUser.fromJson(merged);
  }

  @override
  List<Object?> get props => [uid, name, placa, contato, email];
}
