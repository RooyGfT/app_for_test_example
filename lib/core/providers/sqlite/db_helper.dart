import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'db_helper.g.dart';


abstract class IDBHelper {
  Future<Database> initDB();
}


class DBHelper implements IDBHelper{

  static Database? _db;
  static const int _dbVersion = 1;
  static const String _dbname = 'app.db';

  @override
  Future<Database> initDB()async{
    await deleteDatabase(join(await getDatabasesPath(),_dbname));
    if(_db != null) return _db!;
    final path = join(await getDatabasesPath(),_dbname);
    _db = await openDatabase(
      path,
      version: _dbVersion,  
      onCreate:(db, version)async{
        await _onCreate(db, version);
      }
    );
    return _db!;
  }

  static Future<void> _onCreate(Database db, int version)async{
    await db.execute(
      '''
        CREATE TABLE Todos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          description TEXT,
          done INTEGER
        )
      '''
    );
  }
}

@riverpod
IDBHelper dbHelper(Ref ref){
  return DBHelper();
}

