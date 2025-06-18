part of 'trigger.dart';

class ScheduleTrigger extends Trigger {
  final String time;
  const ScheduleTrigger({required this.time});

  factory ScheduleTrigger.fromJson(Map<String, dynamic> json) =>
      ScheduleTrigger(
        time: json['time'] != null
            ? json["time"].toString()
            : json['value'].toString(), // Adjusted to match the JSON structure
      );
  @override
  Map<String, dynamic> toJson() => {
        "type": "SCHEDULE",
        'value': time,
        'time': time, // Added 'time' to match the JSON structure
      };
}
