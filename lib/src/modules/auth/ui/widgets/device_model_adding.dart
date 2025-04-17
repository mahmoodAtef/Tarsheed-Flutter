import 'package:flutter/material.dart';

class DeviceModel {
  final IconData icon;
  final String name;
  final String type;
  bool isActive;

  DeviceModel({
    required this.icon,
    required this.name,
    required this.type,
    this.isActive = true,
  });
}
