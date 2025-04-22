import 'package:equatable/equatable.dart';

final class DeviceCategory extends Equatable {
  final String id;
  final String arabicName;
  final String englishName;
  final String iconUrl;

  const DeviceCategory(
      {required this.id,
      required this.arabicName,
      required this.englishName,
      required this.iconUrl});

  factory DeviceCategory.fromJson(Map<String, dynamic> json) {
    return DeviceCategory(
      id: json['id'],
      arabicName: json['arabicName'],
      englishName: json['englishName'],
      iconUrl: json['iconUrl'],
    );
  }
  String get name =>
      LocalizationManager.currentLocaleIndex == 0 ? arabicName : englishName;
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  @override
  List<Object?> get props => [id, arabicName, englishName, iconUrl];
}
