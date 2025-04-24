// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';
import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/services/extensions.dart';

class Car extends Equatable {
  final String uid;
  final String plate;
  final CarMarkType mark;
  final String model;

  const Car({
    required this.uid,
    required this.plate,
    required this.mark,
    required this.model,
  });

  factory Car.fromJson(Map<String, dynamic> map) {
    return Car(
      uid: map["uid"] ?? '',
      plate: map['plate'] ?? '',
      mark:
          map['mark'] != null
              ? CarMarkType.values.firstWhere(
                (markType) => markType.name.equals(map['markType']),
              )
              : CarMarkType.none,
      model: map['model'] ?? '',
    );
  }

  factory Car.fromRealtimeJson(Map<String, dynamic> map) {
    return Car(
      uid: map["uid"] ?? '',
      plate: map['plate'],
      mark:
          map['mark'] != null
              ? CarMarkType.values.firstWhere(
                (markType) => markType.name.equals(map['markType']),
              )
              : CarMarkType.none,
      model: map['model'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'plate': plate, 'mark': mark, 'model': model};
  }

  factory Car.empty() {
    return Car(uid: '', plate: '', mark: CarMarkType.none, model: '');
  }

  Car copyWith(Map<String, dynamic> newer) {
    Map<String, dynamic> current = toJson();
    Map<String, dynamic> merged = {...current, ...newer};
    return Car.fromJson(merged);
  }

  @override
  List<Object?> get props => [uid, plate, mark, model];
}
