enum TriggerType { schedule, sensor }

enum ConditionType { device, sensor }

enum ActionType { device, notification }

class ConditionData {
  final ConditionType type;
  String? id;
  int state = 0;
  String operator = '='; // Default operator for sensor conditions

  ConditionData({required this.type});
}

class ActionData {
  final ActionType type;
  String? deviceId;
  String? state;
  String? title;
  String? message;

  ActionData({required this.type});
}
