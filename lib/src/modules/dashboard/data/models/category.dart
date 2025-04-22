import 'package:equatable/equatable.dart';

final class DeviceCategory extends Equatable {
  final String id;
  final String name;
  final String icon;

  const DeviceCategory({required this.id, required this.name,required this.icon});

  factory DeviceCategory.fromJson(Map<String, dynamic> json) {
    return DeviceCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'icon': icon};

  @override
  List<Object?> get props => [id, name, icon];
}
