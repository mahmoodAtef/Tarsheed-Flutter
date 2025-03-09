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
      id: json['id'],
      name: json['name'],
      description: json['description'],
      devicesIds: json['devices_ids'],
    );
  }

  Room copyWith({
    String? name,
    String? description,
    List<String>? devicesIds,
  }) {
    return Room(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      devicesIds: devicesIds ?? this.devicesIds,
    );
  }

  @override
  List<Object?> get props => [id, name, description, devicesIds];
}
