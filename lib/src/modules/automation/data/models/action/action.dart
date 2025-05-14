import 'package:equatable/equatable.dart';

part 'device_action.dart';
part 'notification_action.dart';

class Action extends Equatable {
  const Action();

  factory Action.fromJson(Map<String, dynamic> json) => Action();
  Map<String, dynamic> toJson() => {};
  @override
  List<Object?> get props => [];
}
