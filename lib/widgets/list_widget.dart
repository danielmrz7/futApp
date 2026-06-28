import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/enums.dart';
import 'liga_card.dart';
import 'jogador_card.dart';
import 'partida_card.dart';

class ListWidget extends HookWidget {
  final List jsonObjects;
  final List<String> propertyNames;
  final ItemType itemType;
  final Function() scrollEndedCallback;

  const ListWidget({
    super.key,
    required this.jsonObjects,
    required this.propertyNames,
    required this.itemType,
    required this.scrollEndedCallback,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useScrollController();

    useEffect(() {
      void listener() {
        if (controller.position.pixels >=
            controller.position.maxScrollExtent - 100) {
          scrollEndedCallback();
        }
      }
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.all(12),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: jsonObjects.length + 1,
      itemBuilder: (context, index) {
        if (index == jsonObjects.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: LinearProgressIndicator()),
          );
        }
        return _buildCard(jsonObjects[index], index);
      },
    );
  }

  Widget _buildCard(dynamic obj, int index) {
    switch (itemType) {
      case ItemType.clubs:
        return LigaCard(obj: obj, index: index);
      case ItemType.players:
        return JogadorCard(obj: obj, index: index);
      case ItemType.matches:
        return PartidaCard(obj: obj, index: index);
      default:
        return const SizedBox();
    }
  }
}