// lib/models/languages.dart

class Language {
  final String code;
  final String name;

  Language(this.code, this.name);

  static List<Language> getLanguages() {
    return [
      Language("es", "Español"),
      Language("en", "Inglés"),
      Language("fr", "Francés"),
      Language("de", "Alemán"),
      Language("it", "Italiano"),
      Language("pt", "Portugués"),
      // Agrega más idiomas según sea necesario
    ];
  }
}
