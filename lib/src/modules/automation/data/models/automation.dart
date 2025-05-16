import 'package:equatable/equatable.dart';
import 'package:tarsheed/src/modules/automation/data/models/action/action.dart';
import 'package:tarsheed/src/modules/automation/data/models/condition/condition.dart';
import 'package:tarsheed/src/modules/automation/data/models/trigger/trigger.dart';

class Automation extends Equatable {
  final String? id;
  final String name;

  final List<Action> actions;
  final List<Condition> conditions;
  final Trigger trigger;

  const Automation({
    this.id,
    required this.name,
    required this.actions,
    required this.conditions,
    required this.trigger,
  });

  factory Automation.fromJson(Map<String, dynamic> json) => Automation(
        id: json['id'],
        name: json['name'],
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
    String? name,
    List<Action>? actions,
    List<Condition>? conditions,
    Trigger? trigger,
  }) {
    return Automation(
      id: id ?? this.id,
      name: name ?? this.name,
      actions: actions ?? this.actions,
      conditions: conditions ?? this.conditions,
      trigger: trigger ?? this.trigger,
    );
  }

  @override
  List<Object?> get props => [id, actions, conditions, trigger];
}
