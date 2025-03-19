import 'package:equatable/equatable.dart';

class Device extends Equatable {
  final String name;
  final String id;
  final String type;
  final String? description;
  final String? pinNumber;
  final String? roomId;
  final String? categoryId;
  const Device(
      {required this.name,
      required this.id,
      required this.type,
      this.description,
      this.pinNumber,
      this.roomId,
      this.categoryId});

  Device copyWith({
    String? name,
    String? type,
    String? description,
    String? pinNumber,
    String? roomId,
    String? categoryId,
  }) {
    return Device(
      name: name ?? this.name,
      id: id,
      type: type ?? this.type,
      description: description ?? this.description,
      pinNumber: pinNumber ?? this.pinNumber,
      roomId: roomId ?? this.roomId,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object?> get props => [];
}
