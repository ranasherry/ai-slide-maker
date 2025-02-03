// file added by rizwan
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/slide_history.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/data/slides_history_dbhandler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PresentationHistoryDatabaseHandler {
  static final PresentationHistoryDatabaseHandler db =
      PresentationHistoryDatabaseHandler._init();
  PresentationHistoryDatabaseHandler._init();

  static Database? _database;
  static final _databaseName = 'presentation_test.db';
  static final _slideHistoryTable = 'slides_history';
  static final _slidePalletTable = 'slide_pallet';

  Future<Database> get myDatabase async {
    if (_database != null) return _database!;

    _database = await _initDB(_databaseName);
    print('Database created!');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    print('initializing DB');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Create slideHistoryTable
    await db.execute('''
    CREATE TABLE ${_slideHistoryTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      presentationId INTEGER,
      presentationTitle TEXT NOT NULL,
      slides TEXT NOT NULL,
      styleId TEXT NOT NULL,
      createrId TEXT,
      timestamp INTEGER,
      likesCount INTEGER,
      commentsCount INTEGER
    )
  ''');

    // Create slidePalletTable
    await db.execute('''
    CREATE TABLE ${_slidePalletTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      palletId INTEGER,
      name TEXT NOT NULL,
      slideCategory TEXT NOT NULL,
      bigTitleTColor INTEGER,
      normalTitleTColor INTEGER,
      sectionHeaderTColor INTEGER,
      normalDescTColor INTEGER,
      sectionDescTextColor INTEGER,
      imageList TEXT,
      fadeColor INTEGER,
      isPaid INTEGER, 
      slideTitlesTextProperties TEXT,
      slideSectionHeadersTextProperties TEXT,
      slideSectionContentsTextProperties TEXT
    )
  ''');
  }

  Future<int> insertPresentationHistory(
      MyPresentation presentationHistory) async {
    if (kReleaseMode) {
      // return 0;
    }
    try {
      print('inserting into database $presentationHistory');

      final database = await myDatabase;
      int i = 0;
      presentationHistory.slides[i].slideSections[0].memoryImage = null;
      Map<String, Object?> dataToInsert = presentationHistory.toMapDatabase();
      print(dataToInsert);

      return await database.insert(_slideHistoryTable, dataToInsert);
    } catch (error) {
      print('error occured $error');
      return 0;
    }
  }

  Future<int> insertSlidePallet(SlidePallet slidePallet) async {
    try {
      print('inserting into database $slidePallet');

      final database = await myDatabase;
      Map<String, Object?> dataToInsert = slidePallet.toMap();
      print(dataToInsert);
      return await database.insert(_slidePalletTable, dataToInsert);
    } catch (error) {
      print('error occured $error');
      return 0;
    }
  }

  Future<List<MyPresentation>> fetchAllPresentationHistory() async {
    final database = await myDatabase;
    final results = await database.query(_slideHistoryTable);
    print(results);
    return results.map((e) => MyPresentation.fromMapDatabase(e)).toList();
  }

  Future<List<SlidePallet>> fetchAllSlidePallet() async {
    final database = await myDatabase;
    final results = await database.query(_slidePalletTable);
    print("These are slide Pallets db $results");
    return results.isNotEmpty
        ? results.map((result) => SlidePallet.fromMap(result)).toList()
        : [];
  }

  Future<MyPresentation?> fetchPresentationHistoryById(int id) async {
    final database = await myDatabase;
    final results = await database
        .query(_slideHistoryTable, where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? MyPresentation.fromMap(results.first) : null;
  }

  Future<SlidePallet> fetchSlidePalletById(int id) async {
    final database = await myDatabase;
    final results = await database
        .query(_slidePalletTable, where: 'id = ?', whereArgs: [id]);
    developer.log("slide pallaet get by id in db handler ${results.first}");
    return SlidePallet.fromMap(results.first);
  }

  Future<int> updatePresentationHistory(
      int presentationId, MyPresentation presentationHistory) async {
    final database = await myDatabase;
    return await database.update(
        _slideHistoryTable, presentationHistory.toMapDatabase(),
        where: 'presentationId = ?', whereArgs: [presentationId]);
  }

  Future<int> updateSlidePallet(int slideId, SlidePallet slidePallet) async {
    final database = await myDatabase;
    return await database.update(_slidePalletTable, slidePallet.toMap(),
        where: 'id = ?', whereArgs: [slideId]);
  }
}
