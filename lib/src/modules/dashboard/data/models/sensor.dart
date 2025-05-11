import 'package:equatable/equatable.dart';

class Sensor extends Equatable {
  final String? id;
  final String name;
  final String pinNumber;
  final String description;
  final String roomId;
  final String categoryId;

  const Sensor(
      {this.id,
      required this.name,
      required this.pinNumber,
      required this.description,
      required this.roomId,
      required this.categoryId});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      pinNumber: json['pinNumber'].toString(),
      description: json['description'],
      roomId: json['roomId'],
      categoryId: json['categoryId'],
    );
  }
  Sensor copyWith({
    String? id,
    String? name,
    String? pinNumber,
    String? description,
    String? roomId,
    String? categoryId,
  }) =>
      Sensor(
        id: id ?? this.id,
        name: name ?? this.name,
        pinNumber: pinNumber ?? this.pinNumber,
        description: description ?? this.description,
        roomId: roomId ?? this.roomId,
        categoryId: categoryId ?? this.categoryId,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "pinNumber": pinNumber,
        "description": description,
        "roomId": roomId,
        "categoryId": categoryId
      };

  @override
  List<Object?> get props => [id, name];
}
