import 'package:equatable/equatable.dart';

class Device extends Equatable {
  final String name;
  final String id;
  final String type;

  const Device({required this.name, required this.id, required this.type});
  @override
  List<Object?> get props => [];
}
