import 'package:equatable/equatable.dart';

final class DeviceCategory extends Equatable {
  final String id;
  final String name;

  const DeviceCategory({required this.id, required this.name});

  factory DeviceCategory.fromJson(Map<String, dynamic> json) {
    return DeviceCategory(
      id: json['id'],
      name: json['name'],
    );
  }
  @override
  List<Object?> get props => [];
}
