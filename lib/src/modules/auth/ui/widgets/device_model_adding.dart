import 'package:flutter/material.dart';

class DeviceModel {
  final String icon;
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
