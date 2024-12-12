// lib/translate_text.dart

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/languages.dart';

class TranslateTextPage extends StatefulWidget {
  const TranslateTextPage({Key? key}) : super(key: key);

  @override
  _TranslateTextPageState createState() => _TranslateTextPageState();
}

class _TranslateTextPageState extends State<TranslateTextPage> {
  late stt.SpeechToText _speech;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _recognizedText = "Presiona el botón para hablar";
  String _translatedText = "";
  String sourceLang = "es";
  String targetLang = "en";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) async {
        if (!mounted) return;
        final text = result.recognizedWords;
        if (text.isNotEmpty) {
          print("Texto reconocido: $text");
          setState(() {
            _recognizedText = text;
          });

          final translated = await _translateText(text);
          print("Texto traducido: $translated");
          if (!mounted) return;
          setState(() {
            _translatedText = translated;
          });
        }
      });
    } else {
      setState(() => _isListening = false);
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  Future<String> _translateText(String text) async {
    try {
      print("Texto a traducir: $text");
      final Map<String, dynamic> requestBody = {
        'q': text,
        'source': sourceLang,
        'target': targetLang,
        'format': 'text',
      };
      print("Cuerpo de la solicitud: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse("https://libretranslate-deploy.onrender.com"), // Nuevo endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print("Respuesta HTTP: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['translatedText'];
      } else {
        return "Error en la traducción (HTTP ${response.statusCode}): ${response.body}";
      }
    } catch (e) {
      return "Error al traducir: $e";
    }
  }

  void _selectLanguages() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Seleccionar Idiomas"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: sourceLang,
                items: Language.getLanguages()
                    .map((lang) => DropdownMenuItem(
                  value: lang.code,
                  child: Text(lang.name),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() => sourceLang = value!);
                },
                isExpanded: true,
                hint: const Text("Idioma de Origen"),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: targetLang,
                items: Language.getLanguages()
                    .map((lang) => DropdownMenuItem(
                  value: lang.code,
                  child: Text(lang.name),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() => targetLang = value!);
                },
                isExpanded: true,
                hint: const Text("Idioma de Destino"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voz a Texto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _selectLanguages,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Texto Reconocido:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _recognizedText,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            const Text(
              "Texto Traducido:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _translatedText,
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Text(_isListening ? "Detener" : "Hablar y Traducir"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _flutterTts.stop();
    super.dispose();
  }
}
