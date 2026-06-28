import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewNavBar extends HookWidget {
  final void Function(int) itemSelectedCallback;

  const NewNavBar({super.key, required this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);

    return BottomNavigationBar(
      currentIndex: currentIndex.value,
      backgroundColor: const Color(0xFF1B5E20),
      selectedItemColor: Colors.yellowAccent,
      unselectedItemColor: Colors.white60,
      onTap: (index) {
        currentIndex.value = index;
        itemSelectedCallback(index);
      },
      items: const [
        BottomNavigationBarItem(
          label: 'Ligas',
          icon: Icon(Icons.emoji_events_outlined),
          activeIcon: Icon(Icons.emoji_events),
        ),
        BottomNavigationBarItem(
          label: 'Jogadores',
          icon: Icon(Icons.sports_soccer_outlined),
          activeIcon: Icon(Icons.sports_soccer),
        ),
        BottomNavigationBarItem(
          label: 'Partidas',
          icon: Icon(Icons.scoreboard_outlined),
          activeIcon: Icon(Icons.scoreboard),
        ),
      ],
    );
  }
}
