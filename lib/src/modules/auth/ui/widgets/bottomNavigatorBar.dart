import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int selectindex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 428,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50),
          bottomLeft: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 25,
            offset: Offset(0, -12),
            spreadRadius: 0,
          ),
        ],
      ),
      child: BottomNavigationBar(
          onTap: (val) {
            setState(() {
              selectindex = val;
            });
          },
          currentIndex: selectindex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          fixedColor: Color(0xFF2666DE),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.notification_add_outlined), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: ""),
          ]),
    );
  }
}
