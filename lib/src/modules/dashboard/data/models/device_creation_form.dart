import 'package:equatable/equatable.dart';

class DeviceCreationForm extends Equatable {
  final String name;
  final String description;
  final String pinNumber;
  final String roomId;
  final String categoryId;
  final int priority;

  const DeviceCreationForm({
    required this.name,
    required this.description,
    required this.pinNumber,
    required this.roomId,
    required this.categoryId,
    required this.priority,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'pinNumber': pinNumber,
        'roomId': roomId,
        'categoryId': categoryId,
        'priority': priority,
      };

  @override
  List<Object?> get props => [
        name,
        description,
        pinNumber,
        roomId,
        categoryId,
        priority,
      ];
}
