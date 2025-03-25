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
      id: json['id'],
      name: json['name'],
      pinNumber: json['pinNumber'],
      description: json['description'],
    );
  }

  @override
  List<Object?> get props => [id, name];
}
