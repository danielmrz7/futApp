import 'package:flutter/material.dart';

class JogadorCard extends StatelessWidget {
  final Map obj;
  final int index;

  const JogadorCard({super.key, required this.obj, required this.index});

  static const _positionColors = {
    'Atacante':   Colors.red,
    'Meio-campo': Colors.orange,
    'Defensor':   Colors.blue,
    'Goleiro':    Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    final position = obj['position'] as String? ?? '';
    final color = _positionColors[position] ?? Colors.grey;
    final inicial = (obj['name'] as String? ?? '?')[0];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color,
              child: Text(
                inicial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    obj['name'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${obj['club']} · ${obj['country']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color),
              ),
              child: Text(
                position,
                style: TextStyle(color: color, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
