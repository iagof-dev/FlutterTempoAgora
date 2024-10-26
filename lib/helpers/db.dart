import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  DB._();
  static final DB instance = DB._();

  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initialize();
  }

  _initialize() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'weather.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    //await db.execute();
    //await db.insert();
    await db.execute(_weatherTable);
  }

  Future<void> deleteDatabase() async => databaseFactory
      .deleteDatabase(join(await getDatabasesPath(), 'weather.db'));

  String get _weatherTable =>
      'CREATE TABLE weatherHistory(id integer primary key autoincrement, temp INTEGER not null, humidity INTEGER not null, wind INTEGER not null, time datetime not null);';
}

class DbController extends DB {
  DbController() : super._();

  Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    return await database.query(table);
  }

  Future<List<Map<String, dynamic>>> queryOrder(String table) async {
    final db = await database;
    return await db.query(
      table,
      orderBy: "time DESC",
    );
  }
}
