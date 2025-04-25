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

  const Device({
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
      consumption: json['consumption'],
      priority: json['priority'],
      state: json['state'],
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
      };

  Device copyWith(
      {String? id,
      String? name,
      String? description,
      String? pinNumber,
      String? roomId,
      String? categoryId,
      double? consumption,
      int? priority,
      bool? state}) {
    return Device(
        name: name ?? this.name,
        id: id ?? this.id,
        // type: type ?? this.type,
        description: description ?? this.description,
        roomId: roomId ?? this.roomId,
        consumption: consumption ?? this.consumption,
        categoryId: categoryId ?? this.categoryId,
        priority: priority ?? this.priority,
        state: state ?? this.state);
  }

  @override
  List<Object?> get props => [id, name];
}
/*
 */
