import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/sensor_category.dart';

class Sensor extends Equatable {
  final String? id;
  final String name;
  final String pinNumber;
  final String description;
  final String roomId;
  final String categoryId;
  final SensorCategory category;
  const Sensor(
      {this.id,
      required this.category,
      required this.name,
      required this.pinNumber,
      required this.description,
      required this.roomId,
      required this.categoryId});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      category: fromId(json['categoryId']),
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
        category: category,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "pinNumber": pinNumber,
        "description": description,
        "roomId": roomId,
        "categoryId": categoryId
      };

  static SensorCategory fromId(String id) {
    switch (id) {
      case "6817b4b7f927a0b34e0756d7":
        return SensorCategory.temperature;
      case "6817b5bda500e527dbafb536":
        return SensorCategory.current;
      case "6817b5e3dc386af5382343f3":
        return SensorCategory.vibration;
      default:
        return SensorCategory.motion;
    }
  }

  @override
  List<Object?> get props => [id, name];
}
