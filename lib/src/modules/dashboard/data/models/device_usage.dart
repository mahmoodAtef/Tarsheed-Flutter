import 'package:equatable/equatable.dart';

class DeviceUsage extends Equatable {
  final String deviceID;
  final DateTime timeStamp;
  final double usage;
  final String deviceName;
  const DeviceUsage(
      {required this.deviceID,
      required this.timeStamp,
      required this.usage,
      required this.deviceName});

  factory DeviceUsage.fromJson(Map<String, dynamic> json) => DeviceUsage(
      deviceName: json["deviceName"],
      deviceID: json["deviceId"],
      timeStamp: DateTime.parse(json['timeStamp']),
      usage: json['totalUsage']);

  Map<String, dynamic> toJson() => {
        "deviceName": deviceName,
        "deviceId": deviceID,
        "timeStamp": timeStamp.toIso8601String(),
        "totalUsage": usage
      };
  @override
  List<Object?> get props => [deviceID, usage];
}
