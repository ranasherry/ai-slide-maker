import 'dart:convert';

import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/slide_history.dart';
import 'package:slide_maker/app/data/slides_history_dbhandler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PresentationHistoryDatabaseHandler {

static final PresentationHistoryDatabaseHandler db = PresentationHistoryDatabaseHandler._init();
PresentationHistoryDatabaseHandler._init();

static Database? _database;
static final _databaseName = 'presentation2.db';
static final _tableName = 'slides_history';

Future<Database> get myDatabase async {
  if(_database != null) return _database!;

  _database = await _initDB(_databaseName);
  print('Database created!');
  return _database!;
}

Future<Database> _initDB(String filePath) async {
  print('initializing DB');
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, filePath);
  return await openDatabase(path, version: 5, onCreate : _createDB);

}

Future _createDB(Database db, int version) async{
  // await db.execute('DROP DATABASE IF EXISTS $_databaseName');
  await db.execute('''
  CREATE TABLE $_tableName (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  presentationId INTEGER,
  presentationTitle TEXT NOT NULL,
  slides TEXT NOT NULL
  )
''');
}  

Future<int> insertPresentationHistory(MyPresentation presentationHistory) async{
  try{
  print('inserting into database $presentationHistory');

  final database = await myDatabase;
  Map<String, Object?> dataToInsert = presentationHistory.toMapDatabase();
  // If there's a nested map or list, serialize it to JSON before inserting
// dataToInsert['slides'] = jsonEncode(dataToInsert['slides']); // Assuming 'slides' is the complex data

  return await database.insert(_tableName, dataToInsert);
  }
  catch(error){
    print('error occured $error');
    return 0;
  }
}

Future <List<MyPresentation>> fetchAllPresentationHistory() async {
  final database = await myDatabase;
  final results = await database.query(
    _tableName
  );
  print(results);
  return results.map((e) => MyPresentation.fromMapDatabase(e)).toList();
}

Future <MyPresentation?> fetchPresentationHistoryById(int id) async {
  final database = await myDatabase;
  final results = await database.query(_tableName, where: 'id = ?', whereArgs: [id]);
  return results.isNotEmpty ? MyPresentation.fromMap(results.first) : null;
}

Future <int> updatePresentationHistory(int id, MyPresentation presentationHistory) async {
  final database = await myDatabase;
  return await database.update(_tableName, presentationHistory.toMap(),
  where: 'id = ?', whereArgs: [id]);
}


}