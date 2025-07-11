import 'package:equatable/equatable.dart';

class Device extends Equatable {
  final String name;
  final String id;
  final String description;
  final String roomId;
  final String categoryId;
  final double consumption;
  final int priority;
  final bool state;
  final int pinNumber;
  const Device({
    required this.pinNumber,
    required this.state,
    required this.name,
    required this.id,
    required this.description,
    required this.roomId,
    required this.categoryId,
    required this.consumption,
    required this.priority,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      name: json['name'],
      id: json['id'] ?? json["_id"],
      description: json['description'],
      roomId: json['roomId'],
      categoryId: json['categoryId'],
      consumption:
          json["totalUsage"] == null ? 0 : json['totalUsage']?.toDouble(),
      priority: json['priority'] ?? 0,
      state: json['status'] == "ON",
      pinNumber: json['pinNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'roomId': roomId,
        'categoryId': categoryId,
        'consumption': consumption,
        'priority': priority,
        'state': state,
        'pinNumber': pinNumber
      };

  Device copyWith(
      {String? id,
      String? name,
      String? description,
      int? pinNumber,
      String? roomId,
      String? categoryId,
      double? consumption,
      int? priority,
      bool? state}) {
    return Device(
        name: name ?? this.name,
        id: id ?? this.id,
        description: description ?? this.description,
        roomId: roomId ?? this.roomId,
        consumption: consumption ?? this.consumption,
        categoryId: categoryId ?? this.categoryId,
        priority: priority ?? this.priority,
        state: state ?? this.state,
        pinNumber: pinNumber ?? this.pinNumber);
  }

  @override
  List<Object?> get props => [id, name];
}
