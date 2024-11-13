import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tarea_08/models/incidence.dart';

// Esta clase maneja la conexión a la base de datos SQLite y las operaciones CRUD
// relacionadas con las incidencias (insertar, obtener y eliminar)

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb('incidences.db');
    return _database!;
  }

  Future<Database> _initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    db.execute('''
CREATE TABLE $tableIncidences (
  ${IncidenceFields.id} $idType,
  ${IncidenceFields.title} $textType,
  ${IncidenceFields.description} $textType,
  ${IncidenceFields.date} $textType,
  ${IncidenceFields.imagePath} $textType,
  ${IncidenceFields.audioPath} $textType
)
''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<int> insertIncidence(Incidence incidence) async {
    final db = await instance.database;

    return db.insert(tableIncidences, incidence.toMap());
  }

  Future<int> deleteAllIncidences() async {
    final db = await instance.database;

    return db.delete(tableIncidences);
  }

  Future<List<Incidence>> getIncidences() async {
    final db = await instance.database;

    const orderByDateDesc = '${IncidenceFields.date} DESC';

    List<Map<String, dynamic>> maps =
        await db.query(tableIncidences, orderBy: orderByDateDesc);

    return List.generate(maps.length, (i) => Incidence.fromMap(maps[i]));
  }
}
