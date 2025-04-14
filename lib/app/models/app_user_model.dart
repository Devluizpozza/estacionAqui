import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String name;
  final String contato;
  final String email;
  final String imageUrl;

  const AppUser({
    required this.uid,
    required this.name,
    required this.contato,
    required this.email,
    this.imageUrl = '',
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      contato: json['contato'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'contato': contato,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  factory AppUser.empty() {
    return const AppUser(uid: '', name: '', contato: '', email: '');
  }

  AppUser copyWith(Map<String, dynamic> newer) {
    Map<String, dynamic> current = toJson();
    Map<String, dynamic> merged = {...current, ...newer};
    return AppUser.fromJson(merged);
  }

  @override
  List<Object?> get props => [uid, name, contato, email, imageUrl];
}
