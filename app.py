from flask import Flask, request, jsonify
from googletrans import Translator  # Usamos googletrans para la traducción

app = Flask(__name__)
translator = Translator()

# Ruta principal
@app.route('/')
def home():
    return "API de Traducción en la Nube"

# Ruta para traducir texto
@app.route('/translate', methods=['POST'])
def translate_text():
    try:
        data = request.get_json()  # Recibimos los datos JSON de Flutter
        text = data.get('q')  # Texto a traducir
        source_language = data.get('source')  # Idioma fuente
        target_language = data.get('target')  # Idioma destino

        # Traducir el texto
        translated = translator.translate(text, src=source_language, dest=target_language)

        # Devolver la respuesta
        return jsonify({'translated_text': translated.text})

    except Exception as e:
        return jsonify({'error': str(e)}), 400

if __name__ == '__main__':
    app.run(debug=True)
