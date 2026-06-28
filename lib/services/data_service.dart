import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/enums.dart';

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier =
      ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': [],
    'itemType': ItemType.none,
    'columnNames': [],
    'propertyNames': [],
  });

  int _maxItems = 10;

  void setMaxItems(int max) {
    _maxItems = max;
  }

  void carregar(int index) {
    final funcoes = [carregarClubes, carregarJogadores, carregarPartidas];
    funcoes[index]();
  }

  // ── Aba 0: Ligas (OpenLigaDB) ─────────────────────────────────────────────
  Future<void> carregarClubes() async {
    if (tableStateNotifier.value['status'] == TableStatus.loading) return;

    final bool mesmaAba =
        tableStateNotifier.value['itemType'] == ItemType.clubs;

    if (!mesmaAba) {
      tableStateNotifier.value = {
        'status': TableStatus.loading,
        'dataObjects': [],
        'itemType': ItemType.clubs,
        'columnNames': [],
        'propertyNames': [],
      };
    }

    try {
      final uri = Uri.parse('https://api.openligadb.de/getavailableleagues');
      final jsonString = await http.read(uri);
      final List raw = jsonDecode(jsonString);

      final anterior =
          mesmaAba ? List.from(tableStateNotifier.value['dataObjects']) : [];

      final dados = raw.take(_maxItems).map((e) => {
            'clubName': e['leagueName'] ?? 'N/A',
            'leagueName': e['leagueShortcut'] ?? 'N/A',
            'country': 'Alemanha',
          }).toList();

      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': [...anterior, ...dados],
        'itemType': ItemType.clubs,
        'columnNames': ['Liga', 'Sigla', 'País'],
        'propertyNames': ['clubName', 'leagueName', 'country'],
      };
    } catch (_) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
        'itemType': ItemType.clubs,
        'columnNames': [],
        'propertyNames': [],
      };
    }
  }

  // ── Aba 1: Jogadores (mockados) ───────────────────────────────────────────
  Future<void> carregarJogadores() async {
    if (tableStateNotifier.value['status'] == TableStatus.loading) return;

    final bool mesmaAba =
        tableStateNotifier.value['itemType'] == ItemType.players;

    if (!mesmaAba) {
      tableStateNotifier.value = {
        'status': TableStatus.loading,
        'dataObjects': [],
        'itemType': ItemType.players,
        'columnNames': [],
        'propertyNames': [],
      };
    }

    await Future.delayed(const Duration(milliseconds: 600));

    final List<Map<String, String>> todosJogadores = [
      {'name': 'Lionel Messi',           'position': 'Atacante',   'country': 'Argentina', 'club': 'Inter Miami'},
      {'name': 'Cristiano Ronaldo',       'position': 'Atacante',   'country': 'Portugal',  'club': 'Al Nassr'},
      {'name': 'Kylian Mbappé',          'position': 'Atacante',   'country': 'França',    'club': 'Real Madrid'},
      {'name': 'Erling Haaland',         'position': 'Atacante',   'country': 'Noruega',   'club': 'Man. City'},
      {'name': 'Vinicius Jr.',           'position': 'Atacante',   'country': 'Brasil',    'club': 'Real Madrid'},
      {'name': 'Rodri',                  'position': 'Meio-campo', 'country': 'Espanha',   'club': 'Man. City'},
      {'name': 'Pedri',                  'position': 'Meio-campo', 'country': 'Espanha',   'club': 'Barcelona'},
      {'name': 'Jude Bellingham',        'position': 'Meio-campo', 'country': 'Inglaterra','club': 'Real Madrid'},
      {'name': 'Trent Alexander-Arnold', 'position': 'Defensor',   'country': 'Inglaterra','club': 'Real Madrid'},
      {'name': 'Rúben Dias',            'position': 'Defensor',   'country': 'Portugal',  'club': 'Man. City'},
      {'name': 'Virgil van Dijk',        'position': 'Defensor',   'country': 'Holanda',   'club': 'Liverpool'},
      {'name': 'Alisson Becker',         'position': 'Goleiro',    'country': 'Brasil',    'club': 'Liverpool'},
      {'name': 'Gianluigi Donnarumma',   'position': 'Goleiro',    'country': 'Itália',    'club': 'PSG'},
      {'name': 'Kevin De Bruyne',        'position': 'Meio-campo', 'country': 'Bélgica',   'club': 'Man. City'},
      {'name': 'Lamine Yamal',           'position': 'Atacante',   'country': 'Espanha',   'club': 'Barcelona'},
    ];

    final anterior =
        mesmaAba ? List.from(tableStateNotifier.value['dataObjects']) : [];

    final proximos =
        todosJogadores.skip(anterior.length).take(_maxItems).toList();

    tableStateNotifier.value = {
      'status': TableStatus.ready,
      'dataObjects': [...anterior, ...proximos],
      'itemType': ItemType.players,
      'columnNames': ['Jogador', 'Posição', 'País', 'Clube'],
      'propertyNames': ['name', 'position', 'country', 'club'],
    };
  }

  // ── Aba 2: Partidas (OpenLigaDB — Bundesliga 2023) ────────────────────────
  Future<void> carregarPartidas() async {
    if (tableStateNotifier.value['status'] == TableStatus.loading) return;

    final bool mesmaAba =
        tableStateNotifier.value['itemType'] == ItemType.matches;

    if (!mesmaAba) {
      tableStateNotifier.value = {
        'status': TableStatus.loading,
        'dataObjects': [],
        'itemType': ItemType.matches,
        'columnNames': [],
        'propertyNames': [],
      };
    }

    final anterior =
        mesmaAba ? List.from(tableStateNotifier.value['dataObjects']) : [];
    final rodada = (anterior.length ~/ _maxItems) + 1;

    try {
      final uri = Uri.parse(
          'https://api.openligadb.de/getmatchdata/bl1/2023/$rodada');
      final jsonString = await http.read(uri);
      final List raw = jsonDecode(jsonString);

      final dados = raw.take(_maxItems).map((e) {
        final team1 = e['team1']?['teamName'] ?? 'Time A';
        final team2 = e['team2']?['teamName'] ?? 'Time B';
        final results = e['matchResults'] as List? ?? [];
        final goals1 =
            results.isNotEmpty ? results.last['pointsTeam1'].toString() : '-';
        final goals2 =
            results.isNotEmpty ? results.last['pointsTeam2'].toString() : '-';
        return {
          'mandante': team1,
          'visitante': team2,
          'placar': '$goals1 x $goals2',
        };
      }).toList();

      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': [...anterior, ...dados],
        'itemType': ItemType.matches,
        'columnNames': ['Mandante', 'Visitante', 'Placar'],
        'propertyNames': ['mandante', 'visitante', 'placar'],
      };
    } catch (_) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
        'itemType': ItemType.matches,
        'columnNames': [],
        'propertyNames': [],
      };
    }
  }
}

final dataService = DataService();
