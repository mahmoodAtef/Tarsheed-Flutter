import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFFF3FBFF),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: ColorManager.primary, size: 28),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
