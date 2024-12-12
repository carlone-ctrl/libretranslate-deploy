// lib/translate_voice.dart

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/languages.dart';

class TranslateVoicePage extends StatefulWidget {
  const TranslateVoicePage({Key? key}) : super(key: key);

  @override
  _TranslateVoicePageState createState() => _TranslateVoicePageState();
}

class _TranslateVoicePageState extends State<TranslateVoicePage> {
  late stt.SpeechToText _speech;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
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
          final translated = await _translateText(text);
          print("Texto traducido: $translated");
          if (!mounted) return;

          if (translated.startsWith("Error")) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(translated)),
            );
          } else {
            await _speak(translated);
          }
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
    int retryCount = 0;
    const int maxRetries = 3;
    const Duration retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
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
        } else if (response.statusCode == 429) {
          retryCount++;
          print("Demasiadas solicitudes. Reintentando en ${retryDelay.inSeconds} segundos...");
          await Future.delayed(retryDelay);
        } else {
          return "Error en la traducción (HTTP ${response.statusCode}): ${response.body}";
        }
      } catch (e) {
        return "Error al traducir: $e";
      }
    }

    return "Error en la traducción: Límite de solicitudes alcanzado.";
  }

  Future<void> _speak(String text) async {
    if (text.isEmpty) {
      print("No hay texto para reproducir.");
      return;
    }

    String languageCode;
    switch (targetLang) {
      case "es":
        languageCode = "es-ES";
        break;
      case "en":
        languageCode = "en-US";
        break;
      case "fr":
        languageCode = "fr-FR";
        break;
      case "de":
        languageCode = "de-DE";
        break;
      default:
        languageCode = "en-US";
    }

    print("Configurando idioma para TTS: $languageCode");
    await _flutterTts.setLanguage(languageCode);

    print("Reproduciendo texto: $text");
    await _flutterTts.speak(text);
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
        title: const Text('Voz a Voz en Tiempo Real'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _selectLanguages,
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _isListening ? _stopListening : _startListening,
          child: Text(_isListening ? "Detener" : "Hablar y Traducir"),
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
