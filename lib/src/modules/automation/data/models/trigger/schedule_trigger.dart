part of 'trigger.dart';

class ScheduleTrigger extends Trigger {
  final String time;
  const ScheduleTrigger({required this.time});

  factory ScheduleTrigger.fromJson(Map<String, dynamic> json) =>
      ScheduleTrigger(
        time: json['time'],
      );
  @override
  Map<String, dynamic> toJson() => {
        "type": "SCHEDULE",
        'value': time,
      };
}
