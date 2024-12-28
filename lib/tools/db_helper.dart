import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Singleton pattern for the database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'experiments.db');

    return openDatabase(path, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE experiments(id INTEGER PRIMARY KEY AUTOINCREMENT, experiment_name TEXT, date TEXT, concentration REAL, absorbance REAL)',
      );
    }, version: 1);
  }

  // Insert a full experiment with its observations
  Future<void> insertExperiment(String experimentName, DateTime date, List<Map<String, dynamic>> observations) async {
    final db = await database;

    // Start a batch to insert all observations at once
    var batch = db.batch();

    for (var observation in observations) {
      batch.insert(
        'experiments',
        {
          'experiment_name': experimentName,
          'date': date.toIso8601String(),
          'concentration': observation['concentration'],
          'absorbance': observation['absorbance'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Execute the batch
    await batch.commit();
  }

  // Fetch all observations
  Future<List<Map<String, dynamic>>> getObservations() async {
    final db = await database;
    return db.query('experiments');
  }

  // Delete an observation by ID
  Future<void> deleteObservation(int id) async {
    final db = await database;
    await db.delete(
      'experiments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
