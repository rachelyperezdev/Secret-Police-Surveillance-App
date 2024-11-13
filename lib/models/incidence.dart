// Rachely Esther Pérez Del Villar | 2022-1856

// Nombre de la tabla
const String tableIncidences = 'incidences';

// Campos de la tabla
class IncidenceFields {
  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String date = 'date';
  static const String imagePath = 'imagePath';
  static const String audioPath = 'audioPath';
}

// Modelo
class Incidence {
  final int? id;
  final String title;
  final String description;
  final DateTime date;
  final String imagePath;
  final String audioPath;

  Incidence(
      {this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.imagePath,
      required this.audioPath});

  // Adaptadores
  Map<String, dynamic> toMap() {
    return {
      IncidenceFields.id: id,
      IncidenceFields.title: title,
      IncidenceFields.description: description,
      IncidenceFields.date: date.toIso8601String(),
      IncidenceFields.imagePath: imagePath,
      IncidenceFields.audioPath: audioPath
    };
  }

  factory Incidence.fromMap(Map<String, dynamic> map) {
    return Incidence(
        id: map[IncidenceFields.id] as int,
        title: map[IncidenceFields.title] as String,
        description: map[IncidenceFields.description] as String,
        date: DateTime.parse(map[IncidenceFields.date] as String),
        imagePath: map[IncidenceFields.imagePath] as String,
        audioPath: map[IncidenceFields.audioPath] as String);
  }
}
