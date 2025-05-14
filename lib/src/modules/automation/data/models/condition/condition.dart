import 'package:equatable/equatable.dart';

part 'device_condition.dart';
part 'sensor_condition.dart';

class Condition extends Equatable {
  const Condition();

  factory Condition.fromJson(Map<String, dynamic> json) => Condition();
  Map<String, dynamic> toJson() => {};

  @override
  List<Object?> get props => [];
}
