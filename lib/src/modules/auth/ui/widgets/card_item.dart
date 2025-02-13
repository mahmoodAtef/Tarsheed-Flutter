import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildItem extends StatelessWidget {
  const BuildItem(
      {required this.icon,
      required this.title,
      required this.subtitle,
      this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, top: 12),
        child: Row(
          children: [
            Container(
              height: 66,
              width: 38,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color(0xFF727880),
                      offset: Offset(0, 4),
                      blurRadius: 4)
                ],
                color: Colors.grey[200],
              ),
              child: Icon(
                icon,
                size: 24,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        shadows: [
                          Shadow(
                              color: Color(0xFF727880),
                              offset: Offset(0, 1),
                              blurRadius: 4)
                        ])),
                Text(subtitle,
                    style: TextStyle(
                        color: Color(0xFF727880),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        shadows: [
                          Shadow(
                              color: Color(0xFF727880),
                              offset: Offset(0, 1),
                              blurRadius: 4)
                        ])),
              ],
            )
          ],
        ),
      ),
    );
  }
}
