// lib/main.dart

import 'package:flutter/material.dart';
import 'translate_text.dart';
import 'translate_voice.dart';

void main() {
  runApp(const TraductorVozApp());
}

class TraductorVozApp extends StatelessWidget {
  const TraductorVozApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traductor de Voz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona una Función'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TranslateTextPage()),
                );
              },
              child: const Text('Voz a Texto'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TranslateVoicePage()),
                );
              },
              child: const Text('Voz a Voz en Tiempo Real'),
            ),
          ],
        ),
      ),
    );
  }
}
