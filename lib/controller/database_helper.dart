import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/notes.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('noteList.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const String sql = '''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      periode_tanggal TEXT NOT NULL,
      type_proposal TEXT CHECK(type_proposal IN ('ya','tidak')) NOT NULL,
      link_proposal TEXT NULL,
      prediction_peserta INTEGER NOT NULL,
      real_peserta INTEGER NOT NULL,
      anggaran_prediction INTEGER NOT NULL,
      anggaran_real INTEGER NOT NULL,
      title TEXT NOT NULL,
      deskripsi TEXT NULL,
      sarankritik TEXT NULL
    );
    ''';
    await db.execute(sql);
  }

  Future<List<Notes>> fetchNotesForCurrentMonth() async {
    final db = await instance.database;
    final now = DateTime.now();
    final currentMonthString = DateFormat('yyyy-MM').format(now);

    final result = await db.query(
      'notes',
      where: 'strftime("%Y-%m", periode_tanggal) = ?',
      whereArgs: [currentMonthString],
    );

    return result.map((json) => Notes.fromMap(json)).toList();
  }

  Future<void> insertNote(Notes note) async {
    final db = await instance.database;
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Notes>> fetchNotes() async {
    final db = await instance.database;
    final today = DateTime.now();
    final todayString = DateFormat('yyyy-MM-dd').format(today);
    final result = await db.query(
      'notes',
      where: 'periode_tanggal = ?',
      whereArgs: [todayString],
    );
    return result.map((json) => Notes.fromMap(json)).toList();
  }

  Future<Notes?> fetchNoteById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Notes.fromMap(result.first);
    }
    return null;
  }

  Future<void> updateNote(Notes note) async {
    final db = await database;
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
