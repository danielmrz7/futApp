import 'package:flutter/material.dart';

class LigaCard extends StatelessWidget {
  final Map obj;
  final int index;

  const LigaCard({super.key, required this.obj, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1B5E20),
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          obj['clubName'] ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Sigla: ${obj['leagueName']} · ${obj['country']}',
          style: const TextStyle(color: Colors.white60),
        ),
        trailing: const Icon(Icons.emoji_events, color: Colors.amber),
      ),
    );
  }
}
