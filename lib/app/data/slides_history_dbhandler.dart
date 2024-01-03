import 'package:slide_maker/app/data/slide_history.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SlideHistoryDatabaseHandler {
  static final SlideHistoryDatabaseHandler db =
      SlideHistoryDatabaseHandler._init();

  SlideHistoryDatabaseHandler._init();
  static Database? _database;

  static final _databaseName = 'slides.db';
  static final _tableName = 'slides_history';

  Future<Database> get myDataBase async {
    if (_database != null) return _database!;

    _database = await _initDB(_databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    print("Intializing DB....");
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        timestamp INTEGER,
        slidesList TEXT
      )
    ''');
  }

  Future<int> insertSlideHistory(SlidesHistory slideHistory) async {
    final database = await myDataBase;
    return await database.insert(_tableName, slideHistory.toMap());
  }

  Future<List<SlidesHistory>> fetchAllSlideHistory() async {
    final database = await myDataBase;
    final results = await database.query(_tableName);
    return results.map((result) => SlidesHistory.fromMap(result)).toList();
  }

  Future<SlidesHistory?> fetchSlideHistoryById(int id) async {
    final database = await myDataBase;
    final results =
        await database.query(_tableName, where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? SlidesHistory.fromMap(results.first) : null;
  }

  Future<int> updateSlideHistory(SlidesHistory slideHistory) async {
    final database = await myDataBase;
    return await database.update(_tableName, slideHistory.toMap(),
        where: 'id = ?', whereArgs: [slideHistory.id]);
  }

  Future<int> deleteSlideHistory(int id) async {
    final database = await myDataBase;
    return await database.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
