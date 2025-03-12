import 'package:equatable/equatable.dart';

class DeviceUsage extends Equatable {
  final String deviceID;
  final DateTime timeStamp;
  final double usage;
  const DeviceUsage(
      {required this.deviceID, required this.timeStamp, required this.usage});

  factory DeviceUsage.fromJson(Map<String, dynamic> json) => DeviceUsage(
      deviceID: json["deviceId"],
      timeStamp: DateTime.parse(json['timeStamp']),
      usage: json['usage']);

  @override
  List<Object?> get props => [deviceID, usage];
}
