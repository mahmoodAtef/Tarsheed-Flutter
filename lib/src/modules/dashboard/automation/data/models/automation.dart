import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/modules/dashboard/automation/data/models/action.dart';
import 'package:tarsheed/src/modules/dashboard/automation/data/models/condition.dart';
import 'package:tarsheed/src/modules/dashboard/automation/data/models/trigger.dart';

class Automation extends Equatable {
  final String? id;
  final List<Action> actions;
  final List<Condition> conditions;
  final Trigger trigger;

  const Automation({
    this.id,
    required this.actions,
    required this.conditions,
    required this.trigger,
  });

  factory Automation.fromJson(Map<String, dynamic> json) => Automation(
        id: json['id'],
        actions:
            List<Action>.from(json['actions'].map((x) => Action.fromJson(x))),
        conditions: List<Condition>.from(
            json['conditions'].map((x) => Condition.fromJson(x))),
        trigger: Trigger.fromJson(json['trigger']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'actions': List<dynamic>.from(actions.map((x) => x.toJson())),
        'conditions': List<dynamic>.from(conditions.map((x) => x.toJson())),
        'trigger': trigger.toJson(),
      };

  Automation copyWith({
    String? id,
    List<Action>? actions,
    List<Condition>? conditions,
    Trigger? trigger,
  }) {
    return Automation(
      id: id ?? this.id,
      actions: actions ?? this.actions,
      conditions: conditions ?? this.conditions,
      trigger: trigger ?? this.trigger,
    );
  }

  @override
  List<Object?> get props => [id, actions, conditions, trigger];
}
