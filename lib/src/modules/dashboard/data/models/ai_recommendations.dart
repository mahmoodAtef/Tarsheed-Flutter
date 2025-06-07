import 'package:equatable/equatable.dart';

class AIRecommendations extends Equatable {
  final List<HighConsumptionDevice> highConsumptionDevices;
  final List<String> recommendations;

  const AIRecommendations({
    required this.highConsumptionDevices,
    required this.recommendations,
  });

  factory AIRecommendations.fromJson(Map<String, dynamic> json) {
    return AIRecommendations(
      highConsumptionDevices: (json['highConsumptionDevices'] as List)
          .map((e) => HighConsumptionDevice.fromJson(e))
          .toList(),
      recommendations: List<String>.from(json['recommendations']),
    );
  }

  @override
  List<Object?> get props => [highConsumptionDevices, recommendations];
}

class HighConsumptionDevice extends Equatable {
  final String deviceId;
  final String deviceName;
  final int usage;

  const HighConsumptionDevice({
    required this.deviceId,
    required this.deviceName,
    required this.usage,
  });

  @override
  List<Object?> get props => [deviceId, deviceName, usage];

  factory HighConsumptionDevice.fromJson(Map<String, dynamic> json) {
    return HighConsumptionDevice(
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      usage: json['usage'],
    );
  }
}
