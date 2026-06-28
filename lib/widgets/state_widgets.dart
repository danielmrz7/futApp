import 'package:flutter/material.dart';

class IdleWidget extends StatelessWidget {
  const IdleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('⚽', style: TextStyle(fontSize: 64)),
          SizedBox(height: 16),
          Text(
            'Escolha uma aba abaixo',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF1B5E20)),
          SizedBox(height: 16),
          Text(
            'Carregando dados...',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class FutebolErrorWidget extends StatelessWidget {
  const FutebolErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 64),
          SizedBox(height: 16),
          Text(
            'Erro ao carregar dados.\nTente novamente.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
