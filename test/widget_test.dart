// Este es un test básico de widget para tu aplicación de traducción de voz.

import 'package:flutter_test/flutter_test.dart';

import 'package:traductor_voz/main.dart';

void main() {
  testWidgets('Prueba de pantalla de bienvenida', (WidgetTester tester) async {
    // Construye nuestra aplicación y dispara un frame.
    await tester.pumpWidget(const TraductorVozApp());

    // Verifica que el texto de bienvenida se muestra.
    expect(find.text('¡Bienvenido a tu Traductor de Voz Instantáneo!'), findsOneWidget);
  });
}
