import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../services/data_service.dart';
import '../widgets/list_widget.dart';
import '../widgets/nav_bar.dart';
import '../widgets/state_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚽ Futebol App'),
        actions: [
          PopupMenuButton<int>(
            tooltip: 'Máximo de itens',
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              dataService.setMaxItems(value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Máximo de itens: $value'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 5,  child: Text('5 itens')),
              PopupMenuItem(value: 10, child: Text('10 itens')),
              PopupMenuItem(value: 15, child: Text('15 itens')),
            ],
          ),
        ],
      ),
      body: ValueListenableBuilder<Map<String, dynamic>>(
        valueListenable: dataService.tableStateNotifier,
        builder: (_, state, __) {
          switch (state['status']) {
            case TableStatus.idle:
              return const IdleWidget();
            case TableStatus.loading:
              return const LoadingWidget();
            case TableStatus.ready:
              return ListWidget(
                jsonObjects: state['dataObjects'],
                propertyNames: List<String>.from(state['propertyNames']),
                itemType: state['itemType'],
                scrollEndedCallback: _scrollCallback(state['itemType']),
              );
            case TableStatus.error:
              return const FutebolErrorWidget();
            default:
              return const SizedBox();
          }
        },
      ),
      bottomNavigationBar: NewNavBar(
        itemSelectedCallback: dataService.carregar,
      ),
    );
  }

  Function() _scrollCallback(ItemType? type) {
    switch (type) {
      case ItemType.clubs:   return dataService.carregarClubes;
      case ItemType.players: return dataService.carregarJogadores;
      case ItemType.matches: return dataService.carregarPartidas;
      default:               return () {};
    }
  }
}