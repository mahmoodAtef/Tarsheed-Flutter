import 'package:flutter/material.dart';

class DeviceSearchBar extends StatelessWidget {
  const DeviceSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search devices..',
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.grid_view, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
