import 'package:equatable/equatable.dart';

class Sensor extends Equatable {
  final String id;
  final String name;
  final String pinNumber;
  final String? description;
  const Sensor(
      {required this.id,
      required this.name,
      required this.pinNumber,
      this.description});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      pinNumber: json['pinNumber'],
      description: json['description'],
    );
  }
  Sensor copyWith({
    String? id,
    String? name,
    String? pinNumber,
    String? description,
  }) =>
      Sensor(
        id: id ?? this.id,
        name: name ?? this.name,
        pinNumber: pinNumber ?? this.pinNumber,
        description: description ?? this.description,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "pinNumber": pinNumber,
        "description": description,
      };

  @override
  List<Object?> get props => [id, name];
}
