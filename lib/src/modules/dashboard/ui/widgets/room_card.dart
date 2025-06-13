import 'package:flutter/material.dart';
import 'package:tarsheed/src/modules/dashboard/data/models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const RoomCard({
    super.key,
    required this.room,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading:
            Icon(Icons.meeting_room, color: Theme.of(context).primaryColor),
        title: Text(
          room.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: room.description != null && room.description!.isNotEmpty
            ? Text(room.description!)
            : null,
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
