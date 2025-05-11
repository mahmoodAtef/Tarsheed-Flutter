import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> devicesIds;

  const Room(
      {required this.id,
      required this.name,
      required this.description,
      required this.devicesIds});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      description: json['description'] ?? '',
      devicesIds: List<String>.from(json['roomDevices']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'devices_ids': devicesIds,
      };

  Room copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? devicesIds,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      devicesIds: devicesIds ?? this.devicesIds,
    );
  }

  static const empty = Room(
    id: '',
    name: '',
    description: '',
    devicesIds: [],
  );
  @override
  List<Object?> get props => [id, name, description, devicesIds];
}
