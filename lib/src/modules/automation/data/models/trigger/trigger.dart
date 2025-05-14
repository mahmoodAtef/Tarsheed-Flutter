import 'package:equatable/equatable.dart';

part 'schedule_trigger.dart';
part 'sensor_trigger.dart';

class Trigger extends Equatable {
  const Trigger();

  factory Trigger.fromJson(Map<String, dynamic> json) => Trigger();
  Map<String, dynamic> toJson() => {};

  @override
  List<Object?> get props => [];
}
