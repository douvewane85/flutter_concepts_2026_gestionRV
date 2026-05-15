import 'package:flutter/material.dart';
import 'package:flutter_concepts/models/rendez_vous.dart';
import 'package:intl/intl.dart';

class RVListItem extends StatelessWidget {
  final RendezVous appointment;
  final VoidCallback? onTap;

  const RVListItem({
    super.key,
    required this.appointment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('dd MMM yyyy – HH:mm').format(appointment.date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.event_note, color: Colors.indigo),
        title: Text(appointment.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateString),
            if (appointment.description != null &&
                appointment.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(appointment.description!,
                    style: const TextStyle(color: Colors.grey)),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
